Return-Path: <linux-kernel-owner+w=401wt.eu-S1758410AbZJJLwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410AbZJJLwd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 07:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758268AbZJJLwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 07:52:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758256AbZJJLwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 07:52:31 -0400
Message-ID: <4AD07739.6090509@redhat.com>
Date: Sat, 10 Oct 2009 13:59:53 +0200
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
CC: mtosatti@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] kvm: fix pointer cast
References: <20091009114256.GA29528@gambetta>
In-Reply-To: <20091009114256.GA29528@gambetta>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2009 01:42 PM, Frederik Deweerdt wrote:
> Hi,
>
> On a 32 bits compile, commit 3da0dd433dc399a8c0124d0614d82a09b6a49bce
> introduced the following warnings:
>
> arch/x86/kvm/mmu.c: In function ‘kvm_set_pte_rmapp’:
> arch/x86/kvm/mmu.c:770: warning: cast to pointer from integer of different size
> arch/x86/kvm/mmu.c: In function ‘kvm_set_spte_hva’:
> arch/x86/kvm/mmu.c:849: warning: cast from pointer to integer of different size
>
> The following patch uses 'unsigned long' instead of u64 to match the
> pointer size on both arches.
>
> Regards,
> Frederik
>
>
> Signed-off-by: Frederik Deweerdt<frederik.deweerdt@xprog.eu>
>
>    
Acked-by: Izik Eidus <ieidus@redhat.com>
