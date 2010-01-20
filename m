Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196Ab0ATTtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0ATTtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168Ab0ATTtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:49:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:46244 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab0ATTtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:49:49 -0500
Message-ID: <4B575E35.2050204@kernel.org>
Date: Wed, 20 Jan 2010 11:49:09 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 29/37] sparseirq: change irq_desc_ptrs to static
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org> <1263611228-6751-30-git-send-email-yinghai@kernel.org> <alpine.DEB.2.00.1001191201000.22304@router.home>
In-Reply-To: <alpine.DEB.2.00.1001191201000.22304@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 10:01 AM, Christoph Lameter wrote:
> On Fri, 15 Jan 2010, Yinghai Lu wrote:
> 
>> +void replace_irq_desc(unsigned int irq, struct irq_desc *desc)
>> +{
>> +	if (irq_desc_ptrs && irq < nr_irqs)
>> +		irq_desc_ptrs[irq] = desc;
>> +}
> 
> Why is it now ok to specify an out of range irq number?

ok, will remove this unneeded checking.

YH
