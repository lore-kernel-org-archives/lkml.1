Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab0CJVdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:33:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40780
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932128Ab0CJVdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:33:02 -0500
Date: Wed, 10 Mar 2010 13:33:21 -0800 (PST)
Message-Id: <20100310.133321.134330563.davem@davemloft.net>
To: yinghai@kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] sparc64: use early_res and nobootmem
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100310.133035.84824445.davem@davemloft.net>
References: <1268256267-3769-1-git-send-email-yinghai@kernel.org>
	<1268256267-3769-7-git-send-email-yinghai@kernel.org>
	<20100310.133035.84824445.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 10 Mar 2010 13:30:35 -0800 (PST)

> From: Yinghai Lu <yinghai@kernel.org>
> Date: Wed, 10 Mar 2010 13:24:27 -0800
> 
>> use early_res/fw_memmap to replace lmb, so could use early_res replace bootme
>> later.
>> 
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Why?  What does early_res/fw_memmap do that lmb cannot?

Also, if you're going to use this on non-x86 systems you're
going to have to get rid of "e820" from the interface names.
