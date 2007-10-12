Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbXJLSZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbXJLSZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 14:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbXJLSZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 14:25:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782AbXJLSZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 14:25:22 -0400
Date: Fri, 12 Oct 2007 14:25:04 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: arch merge fallout.
Message-ID: <20071012182504.GA9222@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20071012035743.GA12897@redhat.com> <alpine.LFD.0.999.0710112103240.6887@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710112103240.6887@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[fixed up Cc list that I dorked previously]

On Thu, Oct 11, 2007 at 09:06:42PM -0700, Linus Torvalds wrote> 

 > On Thu, 11 Oct 2007, Dave Jones wrote:
 > >
 > > I had hoped that git would be smart(tm) enough to figure out
 > > that files had moved, and my changes in cpufreq.git would
 > > somehow 're-route' to the right files, but it seems that
 > > git isn't psychic, and gives up.
 > 
 > Actually, git *is* psychic, and can almost certainly do it, but you need 
 > to help it a bit.
 > 
 > Do a
 > 
 > 	git config --global diff.renamelimit 0
 > 
 > to tell git to not give up on just the sheer amount of renames.
 > 
 > (The default git rename detection limit is really designed for 
 > smaller-memory machines)

This still gives me the same problem.

(14:21:29:davej@hera:src)$ git clone -l linus test
Initialized empty Git repository in /home/davej/src/test/.git/
0 blocks
Checking 23014 files out...
 100% (23014/23014) done
(14:21:51:davej@hera:src)$ cd test/
(14:21:54:davej@hera:test)$ git config --global diff.renamelimit 0
(14:21:58:davej@hera:test)$ git pull ../cpufreqremote: Generating pack...
remote: Done counting 174 objects.
remote: Result has 116 objects.
remote: Deltifying 116 objects...
remote:  100% (116/116) done
remote: Total 116 (delta 105), reused 0 (delta 0)
Indexing 116 objects...
 100% (116/116) done
Resolving 105 deltas...
 100% (105/105) done
58 objects were added to complete this thin pack.
CONFLICT (delete/modify): arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c deleted in HEAD and modified in 9eb59573d4b86f347e6cd04f47a4c2082009fa58. Version 9eb59573d4b86f347e6cd04f47a4c2082009fa58 of arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c left in tree.
CONFLICT (delete/modify): arch/i386/kernel/cpu/cpufreq/cpufreq-nforce2.c deleted in HEAD and modified in 9eb59573d4b86f347e6cd04f47a4c2082009fa58. Version 9eb59573d4b86f347e6cd04f47a4c2082009fa58 of arch/i386/kernel/cpu/cpufreq/cpufreq-nforce2.c left in tree.
CONFLICT (delete/modify): arch/i386/kernel/cpu/cpufreq/e_powersaver.c deleted in HEAD and modified in 9eb59573d4b86f347e6cd04f47a4c2082009fa58. Version 9eb59573d4b86f347e6cd04f47a4c2082009fa58 of arch/i386/kernel/cpu/cpufreq/e_powersaver.c left in tree.
CONFLICT (delete/modify): arch/i386/kernel/cpu/cpufreq/elanfreq.c deleted in HEAD and modified in 9eb59573d4b86f347e6cd04f47a4c2082009fa58. Version 9eb59573d4b86f347e6cd04f47a4c2082009fa58 of arch/i386/kernel/cpu/cpufreq/elanfreq.c left in tree.
CONFLICT (delete/modify): arch/i386/kernel/cpu/cpufreq/gx-suspmod.c deleted in HEAD and modified in 9eb59573d4b86f347e6cd04f47a4c2082009fa58. Version 9eb59573d4b86f347e6cd04f47a4c2082009fa58 of arch/i386/kernel/cpu/cpufreq/gx-suspmod.c left in tree.
CONFLICT (delete/modify): arch/i386/kernel/cpu/cpufreq/longhaul.c deleted in HEAD and modified in 9eb59573d4b86f347e6cd04f47a4c2082009fa58. Version 9eb59573d4b86f347e6cd04f47a4c2082009fa58 of arch/i386/kernel/cpu/cpufreq/longhaul.c left in tree.
CONFLICT (delete/modify): arch/i386/kernel/cpu/cpufreq/p4-clockmod.c deleted in HEAD and modified in 9eb59573d4b86f347e6cd04f47a4c2082009fa58. Version 9eb59573d4b86f347e6cd04f47a4c2082009fa58 of arch/i386/kernel/cpu/cpufreq/p4-clockmod.c left in tree.
CONFLICT (delete/modify): arch/i386/kernel/cpu/cpufreq/powernow-k6.c deleted in HEAD and modified in 9eb59573d4b86f347e6cd04f47a4c2082009fa58. Version 9eb59573d4b86f347e6cd04f47a4c2082009fa58 of arch/i386/kernel/cpu/cpufreq/powernow-k6.c left in tree.
CONFLICT (delete/modify): arch/i386/kernel/cpu/cpufreq/powernow-k7.c deleted in HEAD and modified in 9eb59573d4b86f347e6cd04f47a4c2082009fa58. Version 9eb59573d4b86f347e6cd04f47a4c2082009fa58 of arch/i386/kernel/cpu/cpufreq/powernow-k7.c left in tree.
CONFLICT (delete/modify): arch/i386/kernel/cpu/cpufreq/powernow-k8.c deleted in HEAD and modified in 9eb59573d4b86f347e6cd04f47a4c2082009fa58. Version 9eb59573d4b86f347e6cd04f47a4c2082009fa58 of arch/i386/kernel/cpu/cpufreq/powernow-k8.c left in tree.
CONFLICT (delete/modify): arch/i386/kernel/cpu/cpufreq/sc520_freq.c deleted in HEAD and modified in 9eb59573d4b86f347e6cd04f47a4c2082009fa58. Version 9eb59573d4b86f347e6cd04f47a4c2082009fa58 of arch/i386/kernel/cpu/cpufreq/sc520_freq.c left in tree.
CONFLICT (delete/modify): arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c deleted in HEAD and modified in 9eb59573d4b86f347e6cd04f47a4c2082009fa58. Version 9eb59573d4b86f347e6cd04f47a4c2082009fa58 of arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c left in tree.
CONFLICT (delete/modify): arch/i386/kernel/cpu/cpufreq/speedstep-ich.c deleted in HEAD and modified in 9eb59573d4b86f347e6cd04f47a4c2082009fa58. Version 9eb59573d4b86f347e6cd04f47a4c2082009fa58 of arch/i386/kernel/cpu/cpufreq/speedstep-ich.c left in tree.
CONFLICT (delete/modify): arch/i386/kernel/cpu/cpufreq/speedstep-smi.c deleted in HEAD and modified in 9eb59573d4b86f347e6cd04f47a4c2082009fa58. Version 9eb59573d4b86f347e6cd04f47a4c2082009fa58 of arch/i386/kernel/cpu/cpufreq/speedstep-smi.c left in tree.
Auto-merged arch/powerpc/platforms/cell/cbe_cpufreq.c
Automatic merge failed; fix conflicts and then commit the result.

The git on master.kernel.org (1.5.3.4) is pretty recent, so I don't think
that's the problem, is it?

	Dave

-- 
http://www.codemonkey.org.uk
