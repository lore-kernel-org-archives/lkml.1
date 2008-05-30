Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbYE3ERf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbYE3ERf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760866AbYE3ENV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:13:21 -0400
Received: from mail.aknet.ru ([78.158.192.26]:54714 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760862AbYE3ENT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:13:19 -0400
Message-ID: <483F7EBA.1040708@aknet.ru>
Date: Fri, 30 May 2008 08:12:42 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>, ambx1@neo.rr.com,
       david-b@pacbell.net, mingo@elte.hu, tglx@linutronix.de,
       dbrownell@users.sourceforge.net, rmk+lkml@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch][resend] provide rtc_cmos platform device, take 2
References: <200805212334.m4LNY42M006425@imap1.linux-foundation.org> <483BEF1A.3080808@aknet.ru> <20080528163600.b4c3c12c.akpm@linux-foundation.org> <200805290854.54577.bjorn.helgaas@hp.com>
In-Reply-To: <200805290854.54577.bjorn.helgaas@hp.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bjorn Helgaas wrote:
> As far as I'm concerned, "pnpacpi=off" should only be used to work
> around defects, so I'd like to fix the defect you're seeing with
> parport_pc.  Is there a bug report for it?
Certainly, and you've seen it many
times. :)
http://bugzilla.kernel.org/show_bug.cgi?id=7491
Its that the module parameters are overriden
by PNP and are ignored, so you can't do
"dma=none" etc.
Your patch is not for that, AFAICS.
Or let me know if it is.
