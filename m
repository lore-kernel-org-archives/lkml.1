Return-Path: <linux-kernel-owner+w=401wt.eu-S1752375AbZFVSlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbZFVSlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZFVSk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:40:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59738 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbZFVSk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:40:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to disk, mce related?
Date: Mon, 22 Jun 2009 20:41:05 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com> <8db1092f0906221037m30c7966bx6870b4eeb9ee16ea@mail.gmail.com> <8db1092f0906221112y241abc19nb2b0a4a75ef253b4@mail.gmail.com>
In-Reply-To: <8db1092f0906221112y241abc19nb2b0a4a75ef253b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906222041.06103.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Maciej Rutecki wrote:
> 2009/6/22 Maciej Rutecki <maciej.rutecki@gmail.com>:
> 
> > I already do this test:
> > 1. boot, check_interval=0*
> > 2. suspend to disk
> > 3. wait 10 minutes
> > 4. resume
> 5. After resume uptime shows 15 minutes
> 6. wait 15 minutes; nothing happen

Does it mean the box survived the test?

> *Note: I change check_interval for machinecheck0 and machinecheck1.
> 
> Perform any else tests?

Yes, please.

Before 2. in your procedure run 'echo core > /sys/power/pm_test'.  It will not
hibernate then, but it'll run the hibernation sequence including suspending
devices etc.  Next, it'll wait for 5 seconds and run the resume sequence.

Please let me know if the box(es) work(s) correctly after that.

Best,
Rafael
