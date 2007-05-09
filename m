Return-Path: <linux-kernel-owner+w=401wt.eu-S971593AbXEIBVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971593AbXEIBVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968573AbXEIBUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:20:46 -0400
Received: from holomorphy.com ([66.93.40.71]:34987 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbXEIBUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:20:45 -0400
Date: Tue, 8 May 2007 18:21:24 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Minchen Zhao <mzhao@lizotech-inc.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: increase Linux kernel address space 3.5 G memory on Redhat Enterprise version 4
Message-ID: <20070509012124.GJ19966@holomorphy.com>
References: <464113ED.1010104@lizotech-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464113ED.1010104@lizotech-inc.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 05:21:01PM -0700, Minchen Zhao wrote:
> I am running Redhat Linux Enterprise version 4 update 4 on a dual-core 
> 4G memory machine.
> There are many references on the web talking about increasing default 
> user address space
> to 3.5 G however lacking specific instrcutions. My questions:
> 1. What is the specific steps to be done for the kernel to support 3.5 G 
> address space?
> 2. Do I need to re-compile kernel to make this happen? If so, any 
> specific instruction?
> thanks in advance.
> P.S. Please cc to me (mzhao@lizotech-inc.com) to reply.

Use the hugemem kernel instead of the smp kernel. You will get > 3.5GB
user address space.


-- wli
