Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbXJHVvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbXJHVvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 17:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbXJHVvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 17:51:12 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:42334 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753462AbXJHVvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 17:51:11 -0400
Message-ID: <470AA64E.2000807@crispincowan.com>
Date: Mon, 08 Oct 2007 14:51:10 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access
 Control Kernel
References: <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>	<4702B1D5.5050502@tmr.com>	<alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org>	<4703126D.70703@tmr.com>	<alpine.LFD.0.999.0710022050560.3579@woody.linux-foundation.org>	<m17im2pc7x.fsf@ebiederm.dsl.xmission.com>	<15E46546-914A-4A1E-BB0B-642FDA17396B@mac.com>	<m1zlyymaoy.fsf@ebiederm.dsl.xmission.com>	<20071008160611.GA7106@vino.hallyn.com>	<m11wc5a5gp.fsf@ebiederm.dsl.xmission.com>	<20071008180038.GC7106@vino.hallyn.com> <m1hcl11j31.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1hcl11j31.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> My very practical question:  How do I run selinux in one container,
> and SMACK in another?
>   
In AppArmor, we plan to 'containerize' (not sure what to call it) policy
so that you can have an AppArmor policy per container. This is not
currently the case, it is just the direction we want to go. We think it
would be very useful for virtual hosts to be able to have their own
AppArmor policy, independent of what other hosts are doing.

The major step towards this goal so far is that AppArmor rules are now
canonicalized to the name space.

However, I have never considered the idea of separate LSM modules per
container. The idea doesn't really make sense to me. It is kind of like
asking for private device drivers, or even a private kernel, per name
space. If that's what you want, use virtualization like KVM, Xen, or VMware.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
	       Itanium. Vista. GPLv3. Complexity at work

