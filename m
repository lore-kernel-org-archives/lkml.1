Return-Path: <linux-kernel-owner+w=401wt.eu-S933006AbXJPKj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbXJPKj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758319AbXJPKjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:39:19 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:39320 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795AbXJPKjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:39:18 -0400
Message-ID: <471494A1.8030504@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2007 16:08:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
References: <200710122231.50739.elendil@planet.nl> <200710161029.27132.borntraeger@de.ibm.com> <471484B3.9010903@linux.vnet.ibm.com> <200710161211.40285.elendil@planet.nl>
In-Reply-To: <200710161211.40285.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Tuesday 16 October 2007, Balbir Singh wrote:
>> I am trying to think out loud as to what the root cause of the problem
>> might be. In one of the discussion threads, I saw utime going backwards,
>> which seemed very odd, I suspect that those are rounding errors.
> 
> I only remembered stime going backwards, but looking back at the mails
> you are right, there has been one case of utime going backwards too.
> stime going backwards happens _much_ more frequently.
> 
>> I have tried and not had any success reproducing the problem, could you
>> please help me with some pointers/steps to reproduce the problem?
> 
> I can reproduce the problem reliably for two KDE programs I have running
> permanently on my system: kontact and amarok. Both of these wake up
> regularly and use some (not very much) processor capacity before going to
> sleep again. Any process that has that that characteristic should do.
> 
> /me thinks a bit and tries something
> 
> lol - I have just managed to reproduce this with 'top' itself :-P
> 

Thanks, I know why I am not seeing the problem. My box has
CONFIG_VIRT_CPU_ACCOUNTING set. I'll find another box and try.



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
