Return-Path: <linux-kernel-owner+w=401wt.eu-S1763942AbXHJWiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763942AbXHJWiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbXHJWiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:38:13 -0400
Received: from gw02.mail.saunalahti.fi ([195.197.172.116]:40364 "EHLO
	gw02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbXHJWiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:38:12 -0400
Date: Sat, 11 Aug 2007 01:38:07 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: early boot lockup with 2.6.23-rc1
Message-ID: <20070810223807.GA1915@nalle>
References: <20070808223120.GA2286@nalle> <46BAC14E.9040604@zytor.com> <20070809182316.GA2289@nalle> <20070809194348.GA2287@nalle> <46BB94B1.9020307@zytor.com> <20070810163324.GA1916@nalle> <46BC962B.9030209@zytor.com> <20070810192030.GB1916@nalle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810192030.GB1916@nalle>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 10:20:31PM +0300, Mikko Rapeli wrote:
> On Fri, Aug 10, 2007 at 09:45:31AM -0700, H. Peter Anvin wrote:
> > Let me get this straight... "edd=skipmbr" boots fine, but commenting out
> > the call to query_edd() didn't?  Could you please try that (and, I
> > guess, only that), and make sure everything necessary is rebuild.
> >
> > 2.6.23-*rc2* you say boots fine with "edd=skipmbr", but not without?
> 
> Yes, vanilla 2.6.23-rc2 with edd=skipmbr boots fine.
> 
> > Did you try the above commenting-out on rc2?
> 
> Yes, didn't work with 2.6.23-rc2 but printed one dot in the upper left
> corner after grub stuff.

Oops, I was wrong and bad enough to think nesting #ifdef's would work;
2.6.23-rc2 with query_mca() to query_edd() in arch/i386/boot/main.c
commented out works.

Sorry about that one.

-Mikko
