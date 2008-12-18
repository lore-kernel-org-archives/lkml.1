Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbYLRX5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbYLRX5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYLRX5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:57:39 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:56386 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYLRX5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:57:38 -0500
Date: Thu, 18 Dec 2008 15:57:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Yinghai Lu <yinghai@kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: Tree for December 18 (irq.h documentation)
Message-Id: <20081218155709.bf435d8c.randy.dunlap@oracle.com>
In-Reply-To: <20081218230637.c879a046.sfr@canb.auug.org.au>
References: <20081218230637.c879a046.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.494AE358.028C:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi YH,

Whenever you update a struct in a header file that uses kernel-doc,
like struct irq_desc in include/linux/irq.h, please also update the
corresponding kernel-doc notation for the new struct members, so
that kernel-doc warnings are not caused:

from linux-next-20081218:

Warning(linux-next-20081218//include/linux/irq.h:192): No description found for parameter 'timer_rand_state'
Warning(linux-next-20081218//include/linux/irq.h:192): No description found for parameter 'kstat_irqs'
Warning(linux-next-20081218//include/linux/irq.h:192): No description found for parameter 'irq_2_iommu'


Please add kernel-doc notation for those missing struct members.

Thanks,
---
~Randy
