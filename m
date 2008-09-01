Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYIAVqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYIAVqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 17:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYIAVqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 17:46:46 -0400
Received: from iabervon.org ([66.92.72.58]:53660 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbYIAVqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 17:46:46 -0400
Date: Mon, 1 Sep 2008 17:46:44 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: linux-kernel@vger.kernel.org
cc: Christopher Desjardins <cddesjardins@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Lenovo 3000 N100 i8042 problems
Message-ID: <alpine.LNX.1.00.0808240148580.19665@iabervon.org>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.25.10, I'm finding that my i8042 seems to die after a while. In the 
middle of using the keyboard and mouse, generally before some key release 
is handled, it stops taking any input.

This seems to be due to 2a2dcd65e232eafd9fb6da1250f83adb57787b42; it works 
fine with that reverted. Perhaps that quirk is being applied too widely? 
Perhaps the workaround doesn't actually work on my computer? I couldn't 
find the bug report that led to that patch, so I'm not sure if I've been 
having whatever problem it was for all along and I never noticed, or if my 
3000 N100 is just different (Lenovo seems to have given a 
specific-sounding number to some very different hardware).

	-Daniel
*This .sig left intentionally blank*
