Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZCNVLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZCNVLl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbZCNVLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:11:31 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:53478 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZCNVLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:11:31 -0400
Date: Sat, 14 Mar 2009 22:13:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jing Huang <huangj@brocade.com>
Cc: James.Bottomley@HansenPartnership.com, kgudipat@brocade.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       rvadivel@brocade.com, vravindr@brocade.com
Subject: Re: [PATCH 0/5] bfa: Brocade BFA FC SCSI driver (overview)
Message-ID: <20090314211328.GC3353@uranus.ravnborg.org>
References: <200903141952.n2EJqeHb028773@blc-10-6.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903141952.n2EJqeHb028773@blc-10-6.brocade.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 12:52:40PM -0700, Jing Huang wrote:
> From: Jing Huang <huangj@brocade.com>
> 
> This is the an interim submission of Brocade BFA FC SCSI Driver for code review.
> We moved FC protocol/port state machine part of the driver to the firmware to
> make the driver simpler. We also implemented the code review comments received
> from last submission which includes: 1) replaced bfa specific list management
> routines by standard linux list implemetation. 2) Other minor fixes such as 
> namming, kconfig etc.
> 
> Please note that this driver is still not fully functioning. We expect to do
> anoher submssion next week after we complete all the changes. 
> 
> It contains a serial of 5 patches generated using 2.6.29-rc8 kernel. Here is
> a brief description of each patch:
> 
> [PATCH 1/5]: Linux driver specific code, things such as module load/unload,
> PCI probe/release, interrupt handler, and sysfs interface etc. All the files
> start with "bfad_" prefix.
> 
> [PATCH 2/5]: Hardware/FW access code. All files start with "bfa_" prefix.
> 
> [PATCH 3/5]: Common header files shared by linux driver specific and
> hardware/FW access code.
> 
> [PATCH 4/5]: Updated Kconfig and Makefile for driver/scsi, and Makefile
> for bfa driver 
> 
> [PATCH 5/5]: Updated MAINTAINER file.

Your submission was screwed up somehow?
You had plenty of [0/5]....

Have you ran this through checkpatch - and what is the result?
Have you run this through sparse - and what is the result?

If you have done it - please document it.
If not then please do - fix relevant issues - and document it.

	Sam
