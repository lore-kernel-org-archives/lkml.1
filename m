Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbZG1Ax0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbZG1Ax0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 20:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbZG1Ax0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 20:53:26 -0400
Received: from usul.saidi.cx ([204.11.33.34]:40671 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750920AbZG1AxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 20:53:24 -0400
Date: Mon, 27 Jul 2009 17:52:59 -0700
From: Philip Langdale <philipl@overt.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: David Vrabel <david.vrabel@csr.com>,
       Andrew Morton <akpm@linux-foundation.org>, ohad@bencohen.org,
       ian@mnementh.co.uk, pierre@ossman.eu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-l@jasper.es
Subject: Re: New MMC maintainer needed
Message-ID: <20090727175259.12014aa2@fido2.homeip.net>
In-Reply-To: <20090727214001.GK12665@console-pimps.org>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
	<20090722151744.fffd7bf5.akpm@linux-foundation.org>
	<4A67A9E8.5080002@mnementh.co.uk>
	<20090723055447.GA12211@console-pimps.org>
	<20090722232259.d0ff3495.akpm@linux-foundation.org>
	<20090724152944.51402e87.akpm@linux-foundation.org>
	<20090726230630.7598fbe4@fido2.homeip.net>
	<4A6D990B.9000005@csr.com>
	<20090727214001.GK12665@console-pimps.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.4; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009 22:40:01 +0100
Matt Fleming <matt@console-pimps.org> wrote:

> On Mon, Jul 27, 2009 at 01:09:47PM +0100, David Vrabel wrote:
> > Philip Langdale wrote:
> > > 
> > > Both the (Simplified) SD and SDIO specifications do not formally
> > > define the 'low voltage' range in the way the MMC spec does. ie:
> > > You won't find anything in the SD specs that even tell you what
> > > the range is - it just says that it exists.
> > 
> > Standard SD/SDIO cards only support 2.7-3.6V.
> > 
> > 1.8V operation is added in SD physical spec 3.00 and is part of any
> > of the UHS-1 modes (SDR12-SDR104 and DDR50).  It has a different
> > timings and requires a different (3.00 compliant) host controller.
> 
> Is the 3.00 spec publicly available?
> 

Indeed! If the 1.8V operations have conformance requirements beyond
those of MMCplus/MMCmobile, then we can't just remove the current
test as proposed. I've been checking the sdcard.org site periodically
for new specs and haven't seen anything yet.

--phil
