Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbYGLEvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbYGLEvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 00:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYGLEvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 00:51:40 -0400
Received: from wsip-68-15-230-7.om.om.cox.net ([68.15.230.7]:42157 "EHLO
	hachi.dashjr.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751216AbYGLEvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 00:51:39 -0400
From: Luke -Jr <luke@dashjr.org>
Organization: -Jr Family
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: suspend/idle hanging
Date: Fri, 11 Jul 2008 23:51:32 -0500
User-Agent: KMail/1.9.9
PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
Jabber-ID: luke@dashjr.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807112351.34997.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I finally got Linux and BusyBox booting on my board, but I've encountered a 
fairly odd problem... any task that sleeps just goes dead entirely, never 
resuming. If I enable networking support, this seems to happen before init is 
even spawned (in this case, inside cpu_idle() according to remote gdb).

I'm guessing interrupts aren't firing for some reason, but does anyone else 
have any ideas? Maybe this is more obvious/common than I'm guessing.

Thanks,

Luke
