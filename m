Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbXEFUwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbXEFUwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbXEFUwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:52:12 -0400
Received: from outmx038.isp.belgacom.be ([195.238.6.175]:52477 "EHLO
	outmx038.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbXEFUwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:52:11 -0400
Date: Sun, 6 May 2007 22:53:20 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Dan Williams <dan.j.williams@gmail.com>
Cc: "Curt E. Bruns" <curt.e.bruns@intel.com>,
       Peter Milne <peter.milne@d-tacq.com>,
       Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [2.6.22 patch] iop: combined watchdog timer driver for iop3xx and iop13xx
Message-ID: <20070506205320.GA6486@infomag.infomag.iguana.be>
References: <1177952240.12134.10.camel@dwillia2-linux.ch.intel.com> <20070506095256.GA2521@infomag.infomag.iguana.be> <e9c3a7c20705061313g2b110c4ai478bd3d345de3114@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c3a7c20705061313g2b110c4ai478bd3d345de3114@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

> >Could you split this patch into 2 patches: one that deals with the moving 
> >of
> >the architecture dependant code (and explaining why) and one with the new
> >watchdog drivers? I will continue my review today.
> >
> 
> I am one of the maintainers of this architecture, (Lennert Buytenhek
> is the other).  I will go ahead and split this up so you can sign-off
> on the watchdog specific bits.  The intent is to move all hardware
> definitions under #include <asm/hardware.h>.  You are right this
> should have been a separate patch.

I reviewed the rest of the code. Looks OK to me. One small remark though:
Can we change the ifdef's in the code as described in section 2 point 2 of
the Documentation/SubmittingPatches document?

Thanks,
Wim.

