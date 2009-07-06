Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbZGFF3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbZGFF3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 01:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZGFF3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 01:29:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33387 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbZGFF3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 01:29:01 -0400
Date: Mon, 6 Jul 2009 08:28:55 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Avi Kivity <avi@redhat.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: kvm tree build warning
Message-ID: <20090706052855.GL881@redhat.com>
References: <20090706113752.8dec663a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706113752.8dec663a.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 11:37:52AM +1000, Stephen Rothwell wrote:
> Hi Avi,
> 
> Today's linux-next build (x86_64_allmodconfig) produced this warning:
> 
> arch/x86/kvm/lapic.c: In function 'apic_mmio_write':
> arch/x86/kvm/lapic.c:834: warning: 'return' with no value, in function returning non-void
> 
> Introduced by commit 55b23c7377c9f9f0b4a4b90950f0e18b26ac45e8 ("KVM:
> x2apic interface to lapic").
> 
Yes sorry. I see that Sheng Yang already posted the fix.

--
			Gleb.
