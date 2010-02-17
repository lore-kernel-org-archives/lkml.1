Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040Ab0BQEUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 23:20:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50586
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934011Ab0BQEUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 23:20:46 -0500
Date: Tue, 16 Feb 2010 20:21:02 -0800 (PST)
Message-Id: <20100216.202102.71113896.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH net-next 1/2] percpu: add __percpu sparse annotations
 to net
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B7B445A.1080108@kernel.org>
References: <4B7B445A.1080108@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Wed, 17 Feb 2010 10:20:26 +0900

> Add __percpu sparse annotations to net.
> 
> These annotations are to make sparse consider percpu variables to be
> in a different address space and warn if accessed without going
> through percpu accessors.  This patch doesn't affect normal builds.
> 
> The macro and type tricks around snmp stats make things a bit
> interesting.  DEFINE/DECLARE_SNMP_STAT() macros mark the target field
> as __percpu and SNMP_UPD_PO_STATS() macro is updated accordingly.  All
> snmp_mib_*() users which used to cast the argument to (void **) are
> updated to cast it to (void __percpu **).
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: David S. Miller <davem@davemloft.net>

Applied.
