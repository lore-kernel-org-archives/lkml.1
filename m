Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbZK0B40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbZK0B40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 20:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZK0B40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 20:56:26 -0500
Received: from lo.gmane.org ([80.91.229.12]:39707 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbZK0B4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 20:56:25 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
Date: Thu, 26 Nov 2009 20:56:07 -0500
Message-ID: <henbjo$col$1@ger.gmane.org>
References: <4B046AEA.80109@wpkg.org> <c0c067900911181640h64971680l4da14cdbe9fa6d59@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-72-92-176-205.albyny.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 SeaMonkey/1.1.16
In-Reply-To: <c0c067900911181640h64971680l4da14cdbe9fa6d59@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Merillat wrote:
> On Wed, Nov 18, 2009 at 4:45 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> 
>> I have a pretty powerful desktop machine with 8 GB RAM, fast disks with
>> RAID-1 etc.
> 
>> Every 10 minutes or so, machine is really unresponsive, load jumps to 10 or
>> 20. Mouse pointer jumps, it's impossible to change between windows etc.
> 
> This is the type of hefty workstation many of the core developers
> have, running similar workloads, so I'm somewhat surprised that the
> default VM settings have this kind of issue.
> 
>> Do a "swapoff -a", and everything is snappy and responsive as it should,
>> there are no more lags.
> 
> Yes, that's my exact finding.
> 
> Is this weird IO storm happening for anyone else with plenty of memory
> (for their taskload?)

My load is virtually the same a Tomasz describes, virtual machines (including 
this desktop), little backup servers on CentOS-5.3, production Fedora-9 and 10, 
testing FC11 and 12. I see none of this problem, with the Fedora kernel or my 
own build of 2.6.31 whatever was stable two weeks ago.

What is not the same is that all are started from CLI and scripts, because much 
of my VM stuff predates libvirt. So nothing between qemu-kvm and my fingers or 
boot scripts.

I have no idea if this is useful or significant, just sharing it "in case."

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

