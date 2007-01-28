Return-Path: <linux-kernel-owner+w=401wt.eu-S932839AbXA1UgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbXA1UgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 15:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932820AbXA1UgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 15:36:09 -0500
Received: from animx.eu.org ([216.98.75.249]:51902 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932839AbXA1UgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 15:36:08 -0500
X-Greylist: delayed 3021 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Jan 2007 15:36:07 EST
Date: Sun, 28 Jan 2007 14:46:20 -0500
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: AIC7xxx on 2.6.18
Message-ID: <20070128194620.GA6358@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have 2 machine that oops with these cards.

1) The bios has the option to enable/disable option roms on individual PCI
slots.  I have an AHA-39160 and an AHA-2940U/UW (dual channel).  If I
disable option roms, the driver oopses when accessing the 2nd card.

I can get the oops if really needed as I don't like rebooting this machine.

2) I have an AHA-39160 with Apple/Mac firmware.  When attempting to use it
on a PC, the driver oopses presumably because the card wasn't initialized or
something.  I realize this is probably not a supported configuration, but I
don't believe that it should be oopsing.

I can get the oops for this one if it'll help.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
