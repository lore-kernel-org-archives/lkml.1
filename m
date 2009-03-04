Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbZCDI5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbZCDI5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 03:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZCDI5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 03:57:24 -0500
Received: from ping.pong.ch ([212.103.71.101]:59981 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbZCDI5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 03:57:23 -0500
X-Greylist: delayed 1093 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2009 03:57:23 EST
Date: Wed, 4 Mar 2009 09:38:59 +0100
From: Gaudenz Steinlin <gaudenz@soziologie.ch>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org
Subject: commit "radeonfb: Fix resume from D3Cold on some platforms" breaks
	resume from RAM on PowerBook
Message-ID: <20090304083859.GB6889@soziologie.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin

The commit 1fb25cb8b83e85f5bf1a4adb3c9a254c4ce92405 "radeonfb: Fix resume 
from D3Cold on some platforms" breaks resume from suspend to RAM on my
PowerBook (Model PowerBook5,8 with ATI Mobility Radeon 9600 M10).

On resume the pulsing led indicating sleep just changes to solid white
and nothing else happens. 

Reverting this commit on top of the current Linus' tree fixes resume.

Gaudenz


-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
