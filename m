Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbYKDJXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbYKDJXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYKDJXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:23:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58074 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYKDJXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:23:40 -0500
Message-ID: <49101490.8080003@redhat.com>
Date: Tue, 04 Nov 2008 11:23:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 3 (kvm)(resend/lost)
References: <20081103183214.aac32543.sfr@canb.auug.org.au> <20081103112018.5823291b.randy.dunlap@oracle.com>
In-Reply-To: <20081103112018.5823291b.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Mon, 3 Nov 2008 18:32:14 +1100 Stephen Rothwell wrote:
>
>
> When CONFIG_PCI=n, kvm build on i386 gets:
>
> arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_free_assigned_device':
> arch/x86/kvm/../../../virt/kvm/kvm_main.c:155: error: implicit declaration of function 'pci_reset_function'
> make[2]: *** [arch/x86/kvm/../../../virt/kvm/kvm_main.o] Error 1
>   

I'll add a depends on PCI.  Thanks.


-- 
error compiling committee.c: too many arguments to function

