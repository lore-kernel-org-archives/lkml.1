Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbXDASwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbXDASwa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933888AbXDASwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:52:30 -0400
Received: from smtpout.mac.com ([17.250.248.183]:56984 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933883AbXDASw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:52:29 -0400
In-Reply-To: <Pine.LNX.4.61.0704012040220.15102@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012006060.12316@yvahk01.tjqt.qr> <B118D361-9F40-456F-96B7-E61B16B98432@mac.com> <Pine.LNX.4.61.0704012040220.15102@yvahk01.tjqt.qr>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <2E204ACD-E697-42C6-8F01-22C1B7B4A85B@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH 07/16] kconfig-dynamic-frequency.diff
Date: Sun, 1 Apr 2007 14:52:15 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 01, 2007, at 14:42:59, Jan Engelhardt wrote:
> But I would have to ask: Why do we need 100/250/300/1000 if there  
> is anyway an input field for the user to enter - s/he should read  
> the help text for Known Good values, should not s/he?

Actually, probably what should be done is make the "HZ_CUSTOM" option  
depend on EXPERIMENTAL/ 
EMBEDDED/"EXPERT"/"I_KNOW_WHAT_THE_HELL_IM_DOING" or some other  
equivalent option, because a wrong choice for HZ has the potential to  
really screw up a system.  For example, 10000+ would make most  
systems spend a significant portion of their time processing timer  
interrupts and context switches, and less than 100 or so would make  
the system seem jerky.  The point is to encourage the average kernel  
builder not to change from one of the default options unless they  
really know what they're doing.

Cheers,
Kyle Moffett

