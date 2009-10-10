Return-Path: <linux-kernel-owner+w=401wt.eu-S1761612AbZJJPeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612AbZJJPeY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbZJJPeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:34:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbZJJPeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:34:23 -0400
Date: Sat, 10 Oct 2009 12:32:16 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, joerg.roedel@amd.com,
       stable@kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: patch
	kvm-svm-fix-tsc-offset-adjustment-when-running-nested.patch added
	to 2.6.31-stable tree
Message-ID: <20091010153216.GB3585@amt.cnet>
References: <20091009223815.20569488DB@coco.kroah.org> <200910101540.06686.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910101540.06686.s.L-H@gmx.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 03:40:05PM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Saturday 10 October 2009, gregkh@suse.de wrote:
> > This is a note to let you know that we have just queued up the patch titled
> > 
> >     Subject: KVM: SVM: Fix tsc offset adjustment when running nested
> > 
> > to the 2.6.31-stable tree.  Its filename is
> > 
> >     kvm-svm-fix-tsc-offset-adjustment-when-running-nested.patch
> 
> This patch breaks compilation of 2.6.31.4-rc1 and 2.6.31.4-rc2, as it 
> seems to depend on several prior optimisations to kvm's/ svm's nested 
> behaviour:
> 
> [...]
>   CC [M]  arch/x86/kvm/svm.o
> arch/x86/kvm/svm.c: In function 'svm_vcpu_load':
> arch/x86/kvm/svm.c:713: error: 'struct vcpu_svm' has no member named 'nested'
> make[2]: *** [arch/x86/kvm/svm.o] Error 1
> make[1]: *** [arch/x86/kvm] Error 2
> make: *** [arch/x86] Error 2
> 
> Regards
> 	Stefan Lippers-Hollmann

Greg,

Please drop the patch.

Thanks

