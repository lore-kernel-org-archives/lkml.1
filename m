Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZBSQmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZBSQmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 11:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZBSQmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 11:42:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:58280 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbZBSQmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 11:42:01 -0500
Cc: <olof@lixom.net>, <leoli@freescale.com>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
Message-Id: <D3F7F9FD-94AD-4FA0-9FDF-DFF92487E5DE@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: "<dayu@datangmobile.cn>" <dayu@datangmobile.cn>
In-Reply-To: <D728AD1FA2543948B89DE29C5BF4CD0716AF9623@bjmail1.bj.datangmobile.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] fix the interrupt loss problem on powerpc IPIC(2.6.25-2.6.28)
Date: Thu, 19 Feb 2009 10:41:40 -0600
References: <D728AD1FA2543948B89DE29C5BF4CD0716AF9623@bjmail1.bj.datangmobile.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 17, 2009, at 11:47 PM, <dayu@datangmobile.cn> <dayu@datangmobile.cn 
 > wrote:

>
> From: Da Yu <dayu@datangmobile.cn>
> Date: Wed, 18 Feb 2009 19:58:20 +0800
> Subject: [PATCH] fix the interrupt loss problem on powerpc IPIC  
> (2.6.25-2.6.28)
>
> Description: The interrupt pending register is write 1 clear.  If  
> there are more than one external interrupts pending at the same  
> time, acking the first interrupt by reading pending register then OR  
> the corresponding bit and write back to pending register will also  
> clear other interrupt pending bits.  That will cause loss of  
> interrupt.
>
> Signed-off-by: Da Yu <dayu@datangmobile.cn>
> ---


applied to next

- k
