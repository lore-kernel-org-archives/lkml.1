Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZIXHvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZIXHvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 03:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZIXHvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 03:51:12 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:50215 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZIXHvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 03:51:12 -0400
Message-ID: <4ABB24F2.6070700@petalogix.com>
Date: Thu, 24 Sep 2009 09:51:14 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: stefani@seibold.net
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       John Williams <john.williams@petalogix.com>
Subject: Microblaze noMMU compilation fault - mm/Makefile
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefani,

Commit d899bf7b55f503ba7d3d07ed27c3a37e270fa7db break Microblaze noMMU kernel

There is problem that you setup compilation pagewalk.c which is MMU specific.

And Andrew add there this comment:
[akpm@linux-foundation.org: fs/proc/array.c now needs walk_page_range()]

that mean that the second problem is with compilation of proc/array.c for noMMU.

Thanks for fixing,
Michal

-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
