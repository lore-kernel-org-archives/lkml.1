Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbZJLTSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbZJLTSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZJLTSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:18:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463AbZJLTSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:18:31 -0400
Date: Mon, 12 Oct 2009 15:38:54 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] kvm: fix pointer cast
Message-ID: <20091012183854.GB13210@amt.cnet>
References: <20091009114256.GA29528@gambetta> <4AD07739.6090509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AD07739.6090509@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 01:59:53PM +0200, Izik Eidus wrote:
> On 10/09/2009 01:42 PM, Frederik Deweerdt wrote:
>> Hi,
>>
>> On a 32 bits compile, commit 3da0dd433dc399a8c0124d0614d82a09b6a49bce
>> introduced the following warnings:
>>
>> arch/x86/kvm/mmu.c: In function ‘kvm_set_pte_rmapp’:
>> arch/x86/kvm/mmu.c:770: warning: cast to pointer from integer of different size
>> arch/x86/kvm/mmu.c: In function ‘kvm_set_spte_hva’:
>> arch/x86/kvm/mmu.c:849: warning: cast from pointer to integer of different size
>>
>> The following patch uses 'unsigned long' instead of u64 to match the
>> pointer size on both arches.
>>
>> Regards,
>> Frederik
>>
>>
>> Signed-off-by: Frederik Deweerdt<frederik.deweerdt@xprog.eu>
>>
>>    
> Acked-by: Izik Eidus <ieidus@redhat.com>

Applied, thanks.

