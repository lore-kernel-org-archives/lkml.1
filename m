Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbZIQFyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbZIQFyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 01:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbZIQFya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 01:54:30 -0400
Received: from mail-px0-f202.google.com ([209.85.216.202]:35101 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZIQFya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 01:54:30 -0400
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2009 01:54:30 EDT
MIME-Version: 1.0
Date: Thu, 17 Sep 2009 15:46:26 +1000
Message-ID: <1d3f23370909162246v308da10aga5c4c76d5584341b@mail.gmail.com>
Subject: microblaze: commit 95521585 breakage
From: John Williams <john.williams@petalogix.com>
To: Michal Simek <michal.simek@petalogix.com>, Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam, Michal,

Your MicroBlaze arch makefile cleanup commit
9552158573f847aa429334bb97995bb290bb4b0d had a rather unfortunate
error in it:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=950b260ed21fdb6fa5f18485dabb0b03488431fa

You intended to change CFLAGS_KERNEL to KBUILD_CFLAGS, but instead
changed CFLAGS_KERNEL to KBUILD_KERNEL.

The result?  No CPU feature optimisations across the entire MicroBlaze
kernel build :(

The fix is trivial - may I leave it to you to resolve and merge as
soon as possible?  This is a pretty serious performance regression.

Thanks,

John
-- 
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
