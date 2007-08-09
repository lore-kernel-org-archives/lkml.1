Return-Path: <linux-kernel-owner+w=401wt.eu-S1761746AbXHIW1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761746AbXHIW1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 18:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbXHIW1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 18:27:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59311 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbXHIW1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 18:27:01 -0400
Message-ID: <46BB94B1.9020307@zytor.com>
Date: Thu, 09 Aug 2007 15:26:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mikko Rapeli <mikko.rapeli@iki.fi>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: early boot lockup with 2.6.23-rc1
References: <20070808223120.GA2286@nalle> <46BAC14E.9040604@zytor.com> <20070809182316.GA2289@nalle> <20070809194348.GA2287@nalle>
In-Reply-To: <20070809194348.GA2287@nalle>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikko Rapeli wrote:
> As I could guess from the changelogs, 2.6.22-git2 works and anything
> after 2.6.22-git3 doesn't.

Okay, here is something to try.  Don't try this unless you haven't
already tested 2.6.23-rc2, since there is a bug that was fixed in
2.6.23-rc2 that might be the cause of your problem (you can test that
easily by specifying edd=skipmbr on the kernel command line.)

Anyway, if that doesn't solve it:

In main() in arch/i386/boot/main.c, please comment out everything from
query_mca() to query_edd(), inclusively.

	-hpa
