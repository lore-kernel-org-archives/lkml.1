Return-Path: <linux-kernel-owner+w=401wt.eu-S932930AbXA1Wd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbXA1Wd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 17:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbXA1Wd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 17:33:56 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:24386 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930AbXA1Wdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 17:33:55 -0500
Date: Sun, 28 Jan 2007 16:32:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: AIC7xxx on 2.6.18
In-reply-to: <fa.nf4vfkoNuYTdmg/Uv/EhEPXuUMU@ifi.uio.no>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: wakko@animx.eu.org
Message-id: <45BD247C.9020407@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.nf4vfkoNuYTdmg/Uv/EhEPXuUMU@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wakko Warner wrote:
> I have 2 machine that oops with these cards.
> 
> 1) The bios has the option to enable/disable option roms on individual PCI
> slots.  I have an AHA-39160 and an AHA-2940U/UW (dual channel).  If I
> disable option roms, the driver oopses when accessing the 2nd card.
> 
> I can get the oops if really needed as I don't like rebooting this machine.
> 
> 2) I have an AHA-39160 with Apple/Mac firmware.  When attempting to use it
> on a PC, the driver oopses presumably because the card wasn't initialized or
> something.  I realize this is probably not a supported configuration, but I
> don't believe that it should be oopsing.
> 
> I can get the oops for this one if it'll help.
> 

I'm guessing these are similar bugs - likely something in the driver 
goes bad if the option ROM didn't initialize the card, but I don't think 
it should be relying on this..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

