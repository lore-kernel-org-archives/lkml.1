Return-Path: <linux-kernel-owner+w=401wt.eu-S1765059AbXJFTK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765059AbXJFTK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 15:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764123AbXJFTKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 15:10:12 -0400
Received: from mail.tmr.com ([64.65.253.246]:41011 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763867AbXJFTKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 15:10:10 -0400
Message-ID: <4707DE96.4090400@tmr.com>
Date: Sat, 06 Oct 2007 15:14:30 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
 Control Kernel
References: <46FEEBD4.5050401@schaufler-ca.com> <20070930011618.ccb8351b.akpm@linux-foundation.org> <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au> <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org> <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil> <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org> <4702B1D5.5050502@tmr.com> <alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org> <4703126D.70703@tmr.com> <alpine.LFD.0.999.0710022050560.3579@woody.linux-foundation.org> <m17im2pc7x.fsf@ebiederm.dsl.xmission.com> <15E46546-914A-4A1E-BB0B-642FDA17396B@mac.com>
In-Reply-To: <15E46546-914A-4A1E-BB0B-642FDA17396B@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On Oct 04, 2007, at 21:44:02, Eric W. Biederman wrote:
>> What we want from the LSM is the ability to say -EPERM when we can 
>> clearly articulate that we want to disallow something.
> 
> This sort of depends on perspective; typically with security 
> infrastructure you actually want "... the ability to return success when 
> we can clearly articulate that we want to *ALLOW* something".  File 
> permissions work this way; we don't have a list of forbidden users 
> attached to each file, we have an owner, a group, and a mode 
> representing positive permissions.  With that said in certain high-risk 
> environments you need something even stronger that cannot be changed by 
> the "owner" of the file, if we don't entirely trust them,
> 
Other than ACLs, of course, which do allow blacklisting individual users.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
