Return-Path: <linux-kernel-owner+w=401wt.eu-S937884AbXHMCvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937884AbXHMCvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 22:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934795AbXHMCvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 22:51:08 -0400
Received: from exchange.columbia.tresys.com ([216.250.243.126]:46102 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934597AbXHMCvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 22:51:08 -0400
X-Greylist: delayed 888 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Aug 2007 22:51:08 EDT
Message-ID: <46BFC39F.1020703@manicmethod.com>
Date: Sun, 12 Aug 2007 22:36:15 -0400
From: Joshua Brindle <method@manicmethod.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
References: <255628.7187.qm@web36607.mail.mud.yahoo.com> <10247DAA-D04B-42D5-B67B-C2D3BD42A94F@mac.com>
In-Reply-To: <10247DAA-D04B-42D5-B67B-C2D3BD42A94F@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Aug 2007 02:36:16.0954 (UTC) FILETIME=[B951A1A0:01C7DD52]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On Aug 12, 2007, at 15:41:46, Casey Schaufler wrote:
>
>> Your boolean solution requires more forthought than the Smack rule 
>> solution, but I'll give it to you once you've fleshed out your "##" 
>> lines.
>
> How does it require more forethought?  When I want to turn it on, I 
> write and load the 5 line policy then add the cronjobs.  Yours 
> involves giving cron unconditional permission to write to your 
> security database (always a bad idea) and then adding similar cronjobs.
>

nit: without the selinux policy server (which is not production ready by 
any means) we have to grant the same to cron in this case (or at least 
to the domain that cron runs the cronjobs in). SELinux and Smack alike 
need special permissions to modify the running policy, no surprises there.

