Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbYE3Pw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbYE3Pw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 11:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYE3PwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 11:52:17 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:39340 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbYE3PwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 11:52:16 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Stas Sergeev <stsp@aknet.ru>
Subject: Re: [patch][resend] provide rtc_cmos platform device, take 2
Date: Fri, 30 May 2008 09:52:14 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, ambx1@neo.rr.com,
       david-b@pacbell.net, mingo@elte.hu, tglx@linutronix.de,
       dbrownell@users.sourceforge.net, rmk+lkml@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <200805212334.m4LNY42M006425@imap1.linux-foundation.org> <200805290854.54577.bjorn.helgaas@hp.com> <483F7EBA.1040708@aknet.ru>
In-Reply-To: <483F7EBA.1040708@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805300952.15969.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 May 2008 10:12:42 pm Stas Sergeev wrote:
> Hello.
> 
> Bjorn Helgaas wrote:
> > As far as I'm concerned, "pnpacpi=off" should only be used to work
> > around defects, so I'd like to fix the defect you're seeing with
> > parport_pc.  Is there a bug report for it?
> Certainly, and you've seen it many
> times. :)
> http://bugzilla.kernel.org/show_bug.cgi?id=7491
> Its that the module parameters are overriden
> by PNP and are ignored, so you can't do
> "dma=none" etc.
> Your patch is not for that, AFAICS.
> Or let me know if it is.

Oh, yeah, that one :-)  No, my patch does nothing for that.

I can't remember why it's so hard to fix that bug.  Maybe now that
we fixed the *other* reason for using "pnpacpi=off", I can take
another look at it and make some progress.  It doesn't *sound* like
it should be hard to fix.

Bjorn

