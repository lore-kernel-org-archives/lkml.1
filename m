Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYHHBtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYHHBtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYHHBtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:49:31 -0400
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:40664 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbYHHBtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:49:31 -0400
Message-ID: <489BA629.4030008@blueyonder.co.uk>
Date: Fri, 08 Aug 2008 02:49:29 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: A question regarding init_mm
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to build the nvidia video module for 2.6.26-git through 
2.6.27-rc2, I get "Unknown symbol init_mm", openSUSE 11.1 Alpha1.
Checking a few places I can see init_mm.
# cat /proc/kallsyms |grep init_mm
ffffffff80630020 D init_mm

# grep init_mm System.map-2.6.27-rc2-smp
ffffffff80630020 D init_mm
/usr/src/linux-2.6.27-rc2/arch/x86/kernel # grep init_mm init_task.c
struct mm_struct init_mm = INIT_MM(init_mm);
EXPORT_UNUSED_SYMBOL(init_mm); /* will be removed in 2.6.26 */

Any thoughts on why it's not seen? No one on the nvidia list has a clue 
either.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

