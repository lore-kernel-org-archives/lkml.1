Return-Path: <linux-kernel-owner+w=401wt.eu-S933748AbXHORXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748AbXHORXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbXHORWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:22:55 -0400
Received: from smtpout.mac.com ([17.250.248.176]:49217 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbXHORWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:22:54 -0400
In-Reply-To: <763705.7247.qm@web52512.mail.re2.yahoo.com>
References: <763705.7247.qm@web52512.mail.re2.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A631EFDE-354D-498E-980E-2B785517AC51@mac.com>
Cc: Valdis.Kletnieks@vt.edu, Michael Tharp <gxti@partiallystapled.com>,
       alan <alan@clueserver.org>, LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Thinking outside the box on file systems
Date: Wed, 15 Aug 2007 13:22:43 -0400
To: Marc Perkel <mperkel@yahoo.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 15, 2007, at 13:09:31, Marc Perkel wrote:
> The idea is that people have permissions - not files.  By people I  
> mean users, groups, managers, applications
> etc. One might even specify that there are no permission  
> restrictions at all. Part of the process would be that the kernel  
> load what code it will use for the permission system. It might even  
> be a little perl script you write.
>
> Also - you aren't even giving permission to access files. It's  
> permission to access name patterns. One could apply REGEX masks to  
> names to determine permissions. So if you have permission to the  
> name you have permission to the file.

Please excuse me, I'm going to go stand over in the corner for a minute.

*hahahahahaa hahahahahaaa hahaa hoo hee snicker sniff*

*wanders back into the conversation*

Sorry about that, pardon me.

I suspect you will find it somewhat hard to convince *anybody* on  
this list to put either a regex engine or a Perl interpreter into the  
kernel.  I doubt you could even get a simple shell-style pattern  
matcher in.  First of all, both of the former chew up enormous gobs  
of stack space *AND* they're NP-complete.  You just can't do such  
matching even in polynomial time, let alone something that scales  
appropriately for an OS kernel like, say, O(log(n)).

Cheers,
Kyle Moffett
