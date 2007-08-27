Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbXH0MLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbXH0MLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXH0MLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:11:42 -0400
Received: from smtpout.mac.com ([17.250.248.185]:54477 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbXH0MLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:11:41 -0400
In-Reply-To: <200708261113.JHH03043.VQOtSOJLFFFHMO@I-love.SAKURA.ne.jp>
References: <46CED214.6050505@gmail.com> <46CED5C6.8050501@gmail.com> <20070825110825.GB5850@ucw.cz> <200708261113.JHH03043.VQOtSOJLFFFHMO@I-love.SAKURA.ne.jp>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <60BDD3AF-A5BD-4076-922E-40E629D7CBFA@mac.com>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [TOMOYO 14/15] Conditional permission support.
Date: Mon, 27 Aug 2007 08:11:15 -0400
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 25, 2007, at 22:13:48, Tetsuo Handa wrote:
> Pavel Machek wrote:
>> What is that? Language parser in kernel?
>
> Yes. This is a policy parser in kernel.
>
> TOMOYO Linux' policy is passed from/to the kernel as a plain text  
> (i.e. ASCII printable) file via /proc/tomoyo interface.
>
> For example, to add a permission to allow /usr/sbin/sshd to  
> execute /bin/bash if the authenticated user's uid = 500, the  
> administrator runs
>
> # /bin/cat > /proc/tomoyo/domain_policy << EOF
> select <kernel> /usr/sbin/sshd
> 1 /bin/bash if task.uid=500
> EOF

This is probably not acceptable; I doubt there's a chance in hell  
that TOMOYO will get merged as long as it has text-based-language  
parsing in the kernel.  You also have $NEW_RANDOM_ABUSE_OF_PROCFS and  
$PATH_BASED_LSM_ISSUES.  See the long flamewars on AppArmor for  
discussion on the latter.

Cheers,
Kyle Moffett

