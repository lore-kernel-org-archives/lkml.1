Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbZBGD5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbZBGD5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 22:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZBGD5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 22:57:23 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:38140 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZBGD5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 22:57:22 -0500
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Feb 2009 22:57:22 EST
Date: Fri, 06 Feb 2009 21:57:17 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ben Greear <greearb@candelatech.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PATCH:  (v3) Allow over-ride of smp_found_cfg with kernel cmd-line
 option.
In-reply-to: <498C9D1C.2060302@candelatech.com>
Message-id: <alpine.LFD.2.00.0902062152520.26256@localhost.localdomain>
References: <498B421D.9090609@candelatech.com> <20090205195832.GD3129@elte.hu>
 <498C8DB7.3000005@candelatech.com> <498C8FE8.8090608@oracle.com>
 <498C90D5.9030400@kernel.org> <498C9D1C.2060302@candelatech.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Ok, here's another attempt.  NOTE:  With another patch that Len sent me,
> this work-around seems no longer required for *my* system.  This patch may
> still help others, however...

Ben, your system is fixed by my patch, which makes this code not run.
http://lkml.org/lkml/2009/2/6/354

I do not want to apply the patch in this thread, because
I know of one system it will hurt, and zero systems it will help.

thanks,
-Len
Len Brown, Intel Open Source Technology Center

