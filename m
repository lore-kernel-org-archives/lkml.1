Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbXJYIwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbXJYIwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbXJYIwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:52:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47404 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbXJYIwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:52:01 -0400
Message-ID: <4720592D.4030604@garzik.org>
Date: Thu, 25 Oct 2007 04:51:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: eranian@hpl.hp.com
CC: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, joshua.i.stone@intel.com,
       juan.villacis@intel.com
Subject: Re: [PATCH] IA64/perfmon: kill dead code, clean irq handling
References: <20071023230908.GA12417@havoc.gtf.org> <20071025084615.GA32656@frankl.hpl.hp.com>
In-Reply-To: <20071025084615.GA32656@frankl.hpl.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian wrote:
> Jeff,
> 
> On Tue, Oct 23, 2007 at 07:09:08PM -0400, Jeff Garzik wrote:
>> By deleting unused code, this makes perfmon irq handling more efficient,
>> as well as reducing code size.
>>
>> * remove unused pfm_install_alt_pmu_interrupt()
>> * remove unused pfm_remove_alt_pmu_interrupt()
>>
> I have not problem with the patch except maybe for those two functions.
> How do you know they are not used?
> Have you checked the VTUNE open-source driver?
> I thought at some point they were using this hook.

I was hoping some IA-64 person could speak authoritatively on the subject :)

	Jeff



