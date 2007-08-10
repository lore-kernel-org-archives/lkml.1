Return-Path: <linux-kernel-owner+w=401wt.eu-S941158AbXHJQdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941158AbXHJQdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936336AbXHJQd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:33:29 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:55492 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345AbXHJQd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:33:28 -0400
Date: Fri, 10 Aug 2007 19:33:24 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: early boot lockup with 2.6.23-rc1
Message-ID: <20070810163324.GA1916@nalle>
References: <20070808223120.GA2286@nalle> <46BAC14E.9040604@zytor.com> <20070809182316.GA2289@nalle> <20070809194348.GA2287@nalle> <46BB94B1.9020307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BB94B1.9020307@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 03:26:57PM -0700, H. Peter Anvin wrote:
> Mikko Rapeli wrote:
> > As I could guess from the changelogs, 2.6.22-git2 works and anything
> > after 2.6.22-git3 doesn't.
> 
> Okay, here is something to try.  Don't try this unless you haven't
> already tested 2.6.23-rc2, since there is a bug that was fixed in
> 2.6.23-rc2 that might be the cause of your problem (you can test that
> easily by specifying edd=skipmbr on the kernel command line.)

Nice, 2.6.23-rc2 with edd=skipmbr boots just fine.

> Anyway, if that doesn't solve it:
> 
> In main() in arch/i386/boot/main.c, please comment out everything from
> query_mca() to query_edd(), inclusively.

This didn't help.

-Mikko
