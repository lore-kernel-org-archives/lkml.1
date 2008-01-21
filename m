Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbYAUVTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbYAUVTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYAUVTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:19:46 -0500
Received: from gw.goop.org ([64.81.55.164]:36948 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbYAUVTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:19:45 -0500
Message-ID: <47950C6F.1080308@goop.org>
Date: Mon, 21 Jan 2008 13:19:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Eduardo Pereira Habkost <ehabkost@redhat.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, mingo@elte.hu, gcosta@redhat.com,
       glommer@gmail.com, chrisw@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fill in missing pv_mmu_ops entries for	PAGETABLE_LEVELS
 >= 3
References: <12006768251548-git-send-email-gcosta@redhat.com> <20080119181909.GA4640@dmt> <20080121204451.GT7338@blackpad>
In-Reply-To: <20080121204451.GT7338@blackpad>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Pereira Habkost wrote:
>> +	.pud_clear = native_pud_clear,
>>     
>
> On the patches I will send, pud_clear() and pgd_clear() aren't present
> on pv_mmu_ops and are implemented using set_pud() and set_pgd().
>   

Actually, I changed my mind on that.  pud_clear needs special handling 
with 32-bit PAE, so I'd prefer to keep it a separate operation.

    J
