Return-Path: <linux-kernel-owner+w=401wt.eu-S1765911AbXJSLu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765911AbXJSLu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 07:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755623AbXJSLuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 07:50:51 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:53382 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754009AbXJSLuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 07:50:50 -0400
Message-ID: <4715481F.7060502@blueyonder.co.uk>
Date: Wed, 17 Oct 2007 00:24:15 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-git10 make  bzImage problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When booted, it complains that kernel size is too big, but size OK for a 
bzImage, not for zImage as is returned by the file command, -git9 was 
OK, x86_64 SMP kernel on two 64x2 boxes.
I shall supplymy .config if needed, but they are the same as for -git9.

  # l arch/x86/boot/bzImage
-rw-r--r-- 1 root root 1761496 2007-10-16 22:45 arch/x86/boot/bzImage

# file arch/x86_64/boot/bzImage
arch/x86_64/boot/bzImage: symbolic link to 
`/usr/src/linux-2.6.23-git10/arch/x86/boot/bzImage'

# file arch/x86/boot/bzImage
arch/x86/boot/bzImage: Linux/x86 Kernel, Setup Version 0x206, zImage, 
RO-rootFS, root_dev 0x801, swap_dev 0x1, Prompt for Videomode

Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

