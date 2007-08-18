Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbXHRX0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbXHRX0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 19:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757946AbXHRX01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 19:26:27 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:58751 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878AbXHRX00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 19:26:26 -0400
Subject: Re: Thinking outside the box on file systems
From: Alan <alan@clueserver.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Marc Perkel <mperkel@yahoo.com>, Valdis.Kletnieks@vt.edu,
       Michael Tharp <gxti@partiallystapled.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <A631EFDE-354D-498E-980E-2B785517AC51@mac.com>
References: <763705.7247.qm@web52512.mail.re2.yahoo.com>
	 <A631EFDE-354D-498E-980E-2B785517AC51@mac.com>
Content-Type: text/plain
Date: Sat, 18 Aug 2007 16:26:21 -0700
Message-Id: <1187479581.1608.1.camel@zowie.fnordora.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-15 at 13:22 -0400, Kyle Moffett wrote:
> On Aug 15, 2007, at 13:09:31, Marc Perkel wrote:
> > The idea is that people have permissions - not files.  By people I  
> > mean users, groups, managers, applications
> > etc. One might even specify that there are no permission  
> > restrictions at all. Part of the process would be that the kernel  
> > load what code it will use for the permission system. It might even  
> > be a little perl script you write.
> >
> > Also - you aren't even giving permission to access files. It's  
> > permission to access name patterns. One could apply REGEX masks to  
> > names to determine permissions. So if you have permission to the  
> > name you have permission to the file.
> 
> Please excuse me, I'm going to go stand over in the corner for a minute.
> 
> *hahahahahaa hahahahahaaa hahaa hoo hee snicker sniff*
> 
> *wanders back into the conversation*
> 
> Sorry about that, pardon me.
> 
> I suspect you will find it somewhat hard to convince *anybody* on  
> this list to put either a regex engine or a Perl interpreter into the  
> kernel.  I doubt you could even get a simple shell-style pattern  
> matcher in.  First of all, both of the former chew up enormous gobs  
> of stack space *AND* they're NP-complete.  You just can't do such  
> matching even in polynomial time, let alone something that scales  
> appropriately for an OS kernel like, say, O(log(n)).

Already been done.  Take a look at "AppArmor" aka "Immunix".


