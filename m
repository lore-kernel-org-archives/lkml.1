Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYKYUDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYKYUDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 15:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYKYUD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 15:03:27 -0500
Received: from ping.pong.ch ([212.103.71.101]:55293 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbYKYUD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 15:03:27 -0500
X-Greylist: delayed 1099 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Nov 2008 15:03:26 EST
Date: Tue, 25 Nov 2008 20:44:58 +0100
From: Gaudenz Steinlin <gaudenz@debian.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org
Subject: commit b1ee26b "radeonfb: accelerate imageblit and other
	improvements" freezes system on switching from X to text console
Message-ID: <20081125194457.GA4929@soziologie.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben

The changes in the commit mentioned in the subject freeze my system when
changing from X to a text console. The system freezes with a garbled
display. Reverting this commit fixes the problem.

The freeze only happens if DRI is enabled in X. It also does not happen
if I simply switch between different text consoles. 

My system is a PowerPC PowerBook G4 15" (PowerBook5,8) with a ATI
Mobility Radeon 9600 M10 graphics card. I'm running X.org 1.5.1 with the
radeon driver version 6.9.0+git20080826.a3cc1d7a from Debian
experimental.

Sorry, I don't have the knowledge nor the time to fix this myself, but I
would be happy to test an improved patch. Please also feel free to ask
if you need more information.

Gaudenz

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
