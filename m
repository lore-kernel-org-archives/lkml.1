Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZK0Jd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZK0Jd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 04:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbZK0Jdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 04:33:55 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:42215 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbZK0Jdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 04:33:54 -0500
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: linux-kernel@vger.kernel.org
Subject: Boot cpu != cpu 0 ?
Date: Fri, 27 Nov 2009 12:33:58 +0300
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911271233.58269@zigzag.lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

How hard it could be to build a system on multi-core arm hardware, that has 
linux SMP running in cores other than 0th ?

Say, if bootloader starts kernel on hardware core 1, will kernel be able to 
work (and use cores 1,2,3 on 4-core hardware) after some tweaking? 
Or "boot cpu" concept is uncouplable from "hardware core 0" by 
architecture? 

I'm asking because there is a project with a strict requerement to have 
core 0 reserved and not touched by linux, and I need to understand how 
realistic it is.

Thanks for any hints.

Nikita
