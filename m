Return-Path: <linux-kernel-owner+w=401wt.eu-S1762695AbYAaGTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695AbYAaGTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 01:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYAaGTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 01:19:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:59009 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbYAaGTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 01:19:24 -0500
Cc: <mporter@kernel.crashing.org>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>
Message-Id: <EC566605-6890-4983-8700-3B15C9EFC1C5@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Zhang Wei <wei.zhang@freescale.com>
In-Reply-To: <ABF87B0B6A38C0458E319AC973ED68AEBD0677@zch01exm26.fsl.freescale.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH 4/6] Add multi mport support.
Date: Thu, 31 Jan 2008 00:15:21 -0600
References: <1201689053956-git-send-email-wei.zhang@freescale.com> <12016890621727-git-send-email-wei.zhang@freescale.com> <120168907160-git-send-email-wei.zhang@freescale.com> <12016890773706-git-send-email-wei.zhang@freescale.com> <AF4B8466-C1CE-4FFB-8341-4BFC1CB76116@kernel.crashing.org> <ABF87B0B6A38C0458E319AC973ED68AEBD0677@zch01exm26.fsl.freescale.net>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30, 2008, at 11:57 PM, Zhang Wei wrote:

>
>
>> -----Original Message-----
>> From: Kumar Gala [mailto:galak@kernel.crashing.org]
>>
>> On Jan 30, 2008, at 4:30 AM, Zhang Wei wrote:
>>
>>> Change lots of static variable to mport private. And add
>> mport to some
>>> function declaration.
>>
>> Can you explain this patch further.  Its not clear exactly from this
>> commit message why we are doing this.
>>
>> - k
>
> Sorry about I have a little hurry about it.
>
> The original RapidIO driver suppose there is only one mpc85xx RIO
> controller
> in system. So, some data structures are defined as mpc85xx_rio global,
> such as 'regs_win', 'dbell_ring', 'msg_tx_ring'. Now, I changed them  
> to
> mport's private members. And you can define multi RIO OF-nodes in dts
> file
> for multi RapidIO controller in one processor, such as PCI/PCI-Ex host
> controllers
> in Freescale's silicon. And the mport operation function declaration
> should be changed
> to know which RapidIO controller is target.

thanks, this makes a lot of sense and now reviewing the patch will  
make some sense to me :)

- k
