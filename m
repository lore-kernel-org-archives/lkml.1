Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbXJEDWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbXJEDWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 23:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXJEDWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 23:22:22 -0400
Received: from mx1.lost-oasis.net ([212.85.153.8]:40371 "EHLO
	mx1.lost-oasis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbXJEDWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 23:22:21 -0400
Date: Fri, 5 Oct 2007 05:22:11 +0200
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, Ollie Wild <aaw@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] Linux 2.6.23-rc9 and MAX_ARG_PAGES
Message-ID: <20071005032211.GA3776@bigip.bigip.mine.nu>
Mail-Followup-To: Mathieu Chouquet-Stringer <mchouque@free.fr>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Paul Mackerras <paulus@samba.org>, Ollie Wild <aaw@google.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <m3wsu2u7y6.fsf@bigip.mine.nu> <alpine.LFD.0.999.0710041023480.23684@woody.linux-foundation.org> <20071004204443.GA28483@bigip.bigip.mine.nu> <alpine.LFD.0.999.0710041413020.23684@woody.linux-foundation.org> <18181.26846.253191.684845@cargo.ozlabs.ibm.com> <alpine.LFD.0.999.0710041707260.23684@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710041707260.23684@woody.linux-foundation.org>
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK'.w
	3:{EoxBR
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 05:12:11PM -0700, Linus Torvalds wrote:
> I also tested that "ulimit -s" seems to do the right thing for me.
> 
> I'm also assuming Mathieu is running x86 (or x86-64): HP-PA has a stack 
> that grows upwards, and that has traditionally been exciting.

Correct, x86 it is but as I said it's this stupid auditd thing that
breaks the whole process.  I'm gonna file a bug against it.

Thanks for the help though.
-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
