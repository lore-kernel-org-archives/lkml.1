Return-Path: <linux-kernel-owner+w=401wt.eu-S934883AbXHJWvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934883AbXHJWvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbXHJWux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:50:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60397 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbXHJWuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:50:52 -0400
Message-ID: <46BCEBC7.80303@zytor.com>
Date: Fri, 10 Aug 2007 15:50:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mikko Rapeli <mikko.rapeli@iki.fi>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: early boot lockup with 2.6.23-rc1
References: <20070808223120.GA2286@nalle> <46BAC14E.9040604@zytor.com> <20070809182316.GA2289@nalle> <20070809194348.GA2287@nalle> <46BB94B1.9020307@zytor.com> <20070810163324.GA1916@nalle> <46BC962B.9030209@zytor.com> <20070810192030.GB1916@nalle> <20070810223807.GA1915@nalle>
In-Reply-To: <20070810223807.GA1915@nalle>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikko Rapeli wrote:
> 
> Oops, I was wrong and bad enough to think nesting #ifdef's would work;
> 2.6.23-rc2 with query_mca() to query_edd() in arch/i386/boot/main.c
> commented out works.
> 
> Sorry about that one.
> 

OK, good.  That would be consistent with the current analysis.

Let me know what you get out of the test patch I sent.

	-hpa
