Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbYFDE6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbYFDE6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYFDE5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:57:51 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:42971 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYFDE5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:57:50 -0400
Message-ID: <4846206E.2070507@linux.vnet.ibm.com>
Date: Wed, 04 Jun 2008 10:26:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-fsdevel@vger.kernel.org,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: per_cpu_counter_sum lockdep warning
References: <48460B94.8050000@linux.vnet.ibm.com> <20080604035954.GE3549@parisc-linux.org>
In-Reply-To: <20080604035954.GE3549@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Some percpu counters are supposed to be used from interrupt context.
> These are created with percpu_counter_init_irq.  Others are not and
> should be created with percpu_counter_init.  It seems like someone's
> made a mess of that rule.  This is likely to be a driver, IMO.  Perhaps
> you could work on tracking this down?
> 

Sorry for the noise. It was patch I had applied on my tree, not yet in mainline.
The explanation though did help me find and fix the problem.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
