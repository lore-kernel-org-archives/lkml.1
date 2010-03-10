Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0CJWRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 17:17:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43343
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169Ab0CJWRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 17:17:38 -0500
Date: Wed, 10 Mar 2010 14:17:57 -0800 (PST)
Message-Id: <20100310.141757.95833226.davem@davemloft.net>
To: yinghai@kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] sparc64: use early_res and nobootmem
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B9818CE.7090809@kernel.org>
References: <4B981049.3040607@kernel.org>
	<20100310.133646.144946890.davem@davemloft.net>
	<4B9818CE.7090809@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>
Date: Wed, 10 Mar 2010 14:10:22 -0800

> On 03/10/2010 01:36 PM, David Miller wrote:
>> And LMB cannot fill this void with some minor modifications?
> 
> early_res array could be increased automatically...
> 
> could be something like:
> keep lmb.memory part, and use early_res for reserved parts...

LMB has a reserved region.

I still have yet to see any fundamental reason why LMB
cannot, all by itself, be used to solve this problem too.
