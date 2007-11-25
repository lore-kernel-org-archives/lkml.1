Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbXKYCH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbXKYCH1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 21:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbXKYCHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 21:07:19 -0500
Received: from smtpoutm.mac.com ([17.148.16.79]:58239 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbXKYCHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 21:07:18 -0500
In-Reply-To: <47480D76.8030701@crispincowan.com>
References: <335711.34116.qm@web36610.mail.mud.yahoo.com> <4747C003.3070709@kernel.org> <47480D76.8030701@crispincowan.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <823A64A2-C962-403C-A0EB-95EA79B2DB91@mac.com>
Cc: Andrew Morgan <morgan@kernel.org>, casey@schaufler-ca.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, darwish.07@gmail.com, jmorris@namei.org,
       method@manicmethod.com, paul.moore@hp.com,
       LSM List <linux-security-module@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: + smack-version-11c-simplified-mandatory-access-control-kernel.patch added to -mm tree
Date: Sat, 24 Nov 2007 21:07:09 -0500
To: Crispin Cowan <crispin@crispincowan.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 24, 2007, at 06:39:34, Crispin Cowan wrote:
> Andrew Morgan wrote:
>> It feels to me as if a MAC "override capability" is, if true to  
>> its name, extra to the MAC model; any MAC model that needs an  
>> 'override' to function seems under-specified... SELinux clearly  
>> feels no need for one,
>
> That's not quite right. More specifically, it already has one in  
> the form of unconfined_t. AppArmor has a similar escape hatch in  
> the "Ux" permission. Its not that they don't need one, it is that  
> they already have one. They get to have one because they allow you  
> to actually write a policy that is more nuanced than "process label  
> must dominate object label".

Actually, a fully-secured strict-mode SELinux system will have no  
unconfined_t processes; none of my test systems have any.  Generally  
"unconfined_t" is used for situations similar to what AppArmor was  
designed for, where the only "interesting" security is that of the  
daemon (which is properly labelled) and one or more of the users are  
unconfined.

Even then "unconfined_t" is not an implicit part of the policy, it is  
explicitly given the ability to take any action on any object by  
rules in the policy, and it typically still falls under a few MLS  
labeling restrictions even in the targeted policy.

Cheers,
Kyle Moffett

