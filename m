Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbXKZRgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbXKZRgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 12:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbXKZRg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 12:36:27 -0500
Received: from smtpoutm.mac.com ([17.148.16.78]:64934 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756830AbXKZRg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 12:36:26 -0500
In-Reply-To: <4748EDCB.90403@crispincowan.com>
References: <335711.34116.qm@web36610.mail.mud.yahoo.com> <4747C003.3070709@kernel.org> <47480D76.8030701@crispincowan.com> <823A64A2-C962-403C-A0EB-95EA79B2DB91@mac.com> <4748EDCB.90403@crispincowan.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8F9AE768-CCAB-4D14-BEBA-0A19938113BA@mac.com>
Cc: Andrew Morgan <morgan@kernel.org>, casey@schaufler-ca.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, darwish.07@gmail.com, jmorris@namei.org,
       method@manicmethod.com, paul.moore@hp.com,
       LSM List <linux-security-module@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: + smack-version-11c-simplified-mandatory-access-control-kernel.patch added to -mm tree
Date: Mon, 26 Nov 2007 12:36:09 -0500
To: Crispin Cowan <crispin@crispincowan.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 24, 2007, at 22:36:43, Crispin Cowan wrote:
> Kyle Moffett wrote:
>> Actually, a fully-secured strict-mode SELinux system will have no  
>> unconfined_t processes; none of my test systems have any.   
>> Generally "unconfined_t" is used for situations similar to what  
>> AppArmor was designed for, where the only "interesting" security  
>> is that of the daemon (which is properly labelled) and one or more  
>> of the users are unconfined.
>
> Interesting. In a Targeted Policy, you do your policy  
> administration from unconfined_t. But how do you administer a  
> Strict Policy machine? I can think of 2 ways:

[snip]

> * there is some type that is tighter than unconfined_t but none the
>   less has sufficient privilege to change policy
>
> To me, this would be semantically equivalent to unconfined_t,  
> because any rogue code or user with this type could then fabricate  
> unconfined_t and do what they want

Well, in a strict SELinux system, someone who has been permitted the  
"Security Administrator" role (secadm_r) and who has logged in  
through a "login_t" process may modify and reload the policy.  They  
are also permitted to view all files up to their clearance, write  
files below their level, and relabel files.  On the other hand, they  
do not have any system-administration privileges (those are reserve  
for sysadm_r).

Under the default policy the security administrator may disable  
SELinux completely, although that too can be adjusted as "load  
policy" is yet another specialized permission.

Cheers,
Kyle Moffett
