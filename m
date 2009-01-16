Return-Path: <linux-kernel-owner+w=401wt.eu-S932777AbZAPMHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbZAPMHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757842AbZAPMHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:07:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46041 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584AbZAPMG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:06:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Simon Holm =?utf-8?q?Th=C3=B8gersen?= <odie@cs.aau.dk>
Subject: Re: regression: a0d4922 causes PCI host constroller problems
Date: Fri, 16 Jan 2009 13:06:09 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-tst; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
References: <1232093125.2876.1.camel@odie.local> <1232097368.3120.5.camel@odie.local>
In-Reply-To: <1232097368.3120.5.camel@odie.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901161306.10358.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009, Simon Holm Thøgersen wrote:
> fre, 16 01 2009 kl. 09:05 +0100, skrev Simon Holm Thøgersen:
> > commit a0d4922 ("USB: fix up suspend and resume for PCI host
> > controllers") causes a lot of these two lines to be logged:
> > 
> > uhci_hcd 0000:00:1d.2: host system error, PCI problems?
> > uhci_hcd 0000:00:1d.2: host controller process error, something bad
> > happened!
> > 
> > Normally they appear on resume after suspend to disk, but sometimes I'm
> > not even sure I had to suspend to disk to see them. Also, it seems like
> > they don't trigger if X has not been started, or at least they are much
> > less likely to.
> > 
> > Reverting the patch restores normal operation.
> > 
> > No USB devices were attached BTW.
> 
> So this one has already been reported [1]. There was some mentioning of
> a patch to try out instead of reverting, but I couldn't find it.
> 
> Rafael, did you have something else to suggest or can we please get a
> revert of this one upstream asap before too many are wasting their time
> on this one?

Yes, please try the patch from http://lkml.org/lkml/2009/1/13/144 and report
back.

Thanks,
Rafael
