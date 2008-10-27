Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYJ0U2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYJ0U2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYJ0U2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:28:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:43036 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbYJ0U2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:28:04 -0400
Subject: Re: [PATCH] genirq: Set initial default irq affinity to just CPU0
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Kumar Gala <galak@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       torvalds@osdl.org, maxk@qualcomm.com, tglx@linutronix.de
In-Reply-To: <8440180C-A3B1-4436-9CDF-C6BA9A01F8CD@kernel.crashing.org>
References: <1224863858-7933-1-git-send-email-galak@kernel.crashing.org>
	 <20081024.161813.193686281.davem@davemloft.net>
	 <1224970389.7654.473.camel@pasglop>
	 <20081025.210412.206011121.davem@davemloft.net>
	 <1225002815.7654.487.camel@pasglop>
	 <8440180C-A3B1-4436-9CDF-C6BA9A01F8CD@kernel.crashing.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 07:27:16 +1100
Message-Id: <1225139236.8004.21.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 08:43 -0500, Kumar Gala wrote:
> 
> While we have the comment the code appears not to really follow it.   
> We appear to write 1 << hard_smp_processor_id().

That code is called by each CPU that gets onlined and OR's it's
bit in the mask.

Ben.


