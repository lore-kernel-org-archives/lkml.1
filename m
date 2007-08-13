Return-Path: <linux-kernel-owner+w=401wt.eu-S965440AbXHMCph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440AbXHMCph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 22:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935150AbXHMCp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 22:45:28 -0400
Received: from smtpout.mac.com ([17.250.248.176]:60536 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934597AbXHMCp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 22:45:27 -0400
In-Reply-To: <46BFC39F.1020703@manicmethod.com>
References: <255628.7187.qm@web36607.mail.mud.yahoo.com> <10247DAA-D04B-42D5-B67B-C2D3BD42A94F@mac.com> <46BFC39F.1020703@manicmethod.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <F249B290-129C-4A41-8BBF-2C601D3B00F6@mac.com>
Cc: casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
Date: Sun, 12 Aug 2007 22:45:38 -0400
To: Joshua Brindle <method@manicmethod.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 12, 2007, at 22:36:15, Joshua Brindle wrote:
> Kyle Moffett wrote:
>> On Aug 12, 2007, at 15:41:46, Casey Schaufler wrote:
>>> Your boolean solution requires more forthought than the Smack  
>>> rule solution, but I'll give it to you once you've fleshed out  
>>> your "##" lines.
>>
>> How does it require more forethought?  When I want to turn it on,  
>> I write and load the 5 line policy then add the cronjobs.  Yours  
>> involves giving cron unconditional permission to write to your  
>> security database (always a bad idea) and then adding similar  
>> cronjobs.
>
> nit: without the selinux policy server (which is not production  
> ready by any means) we have to grant the same to cron in this case  
> (or at least to the domain that cron runs the cronjobs in). SELinux  
> and Smack alike need special permissions to modify the running  
> policy, no surprises there.

Yeah, I figured this out a couple minutes ago.  Turns out you can get  
a similar effect with a little properly labeled shell script though  
(text included in my last email), but it does decrease overall system  
security.

Cheers,
Kyle Moffett

