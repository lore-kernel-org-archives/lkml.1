Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZGBTqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZGBTqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 15:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZGBTpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 15:45:54 -0400
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:22330 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753006AbZGBTpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 15:45:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pV3zTJlroepBRV/MKJYoJemApUSAQcHLlsMPfr1NDeo6gNOtEstTPmLr4qWtIFrH9g2Y1Vb9+vnDunZNPpcAnb91rU8tNcChyNytTmMlBarEEUb1TaTGEX+Jcuf5112Rp05gG8svXLUxtzHZ6YAi5A0kG4BHuGjrAcYsMkCu2hU=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: vS61t0kVM1kA77AeDd2I1Z9UuMrmogi0Vrkjhp9Kjgjdz8SXIY6TB4kdU_2OMAbE38YIsX0dCMM.dlw0kMN5mW.7qg2WmHSe8PpRSY4H1CBTC0uMdYGfU6G_fhfOXGr2v7eQQPL9y1wf52tJD9_L_50xn_S_uCOP_WSEnTL_Zn8ZzUGAPY5LOx73VpTQqXcYHBqX.92qUHT926rh2TK9pEk15ti5B0BJW3kjVybwyL_VuQR43pZSJ62d2nzOOrybXH8ffBIRRCLrSOnP
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Du, Alek" <alek.du@intel.com>
Subject: Re: [PATCH] gpio: add Intel Moorestown Platform Langwell chip gpio driver
Date: Thu, 2 Jul 2009 12:45:55 -0700
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
References: <EADF0A36011179459010BDF5142A457501C9F46019@pdsmsx502.ccr.corp.intel.com> <200907011628.08799.david-b@pacbell.net> <EADF0A36011179459010BDF5142A457501C9F4603D@pdsmsx502.ccr.corp.intel.com>
In-Reply-To: <EADF0A36011179459010BDF5142A457501C9F4603D@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907021245.56003.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009, Du, Alek wrote:
> > Is this a dedicated GPIO-only device?  Or is it like e.g. ICH8
> > which shares that device with other functions?
> 
> Yes, the GPIO block is just one function of Langwell chip, the
> Langwell chip is an IOH (IO hub) for the whole system. But the
> devices on the chip are all exposed as PCI devices.  

To be clear:  this PCI function is *only* for GPIO?

Which is unlike the southbridge chips which have an LPC
function, which exposes GPIOs along with other stuff.
(So that LPC function should, arguably, be modeled as an
MFD parent device; or an adapter to an LPC bus.)

