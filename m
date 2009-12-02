Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbZLBCLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbZLBCLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 21:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZLBCLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 21:11:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42791 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111AbZLBCLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 21:11:18 -0500
Date: Wed, 2 Dec 2009 13:11:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Aristeu Rozanski <aris@redhat.com>
Subject: Re: linux-next: i7core_edac tree build failure
Message-Id: <20091202131122.10f61abf.sfr@canb.auug.org.au>
In-Reply-To: <20091116103002.82e8a2bb.sfr@canb.auug.org.au>
References: <20091112165852.855d1e5d.sfr@canb.auug.org.au>
	<200911122340.26317.rusty@rustcorp.com.au>
	<20091113105435.1b9b0060.sfr@canb.auug.org.au>
	<20091116103002.82e8a2bb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Mon, 16 Nov 2009 10:30:02 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> On Fri, 13 Nov 2009 10:54:35 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Yeah, the i7core_edac fix needs to stay in my tree as it is an
> > interaction between two trees in linux-next.  The others should be
> > applied to the powerpc and sparc trees, as you say, since they fix the
> > current code in those trees.
> 
> Actually, Mauro, this patch should be applied to the i7core_edac as that
> symbol never needed to be exported and the patch to export it is in that
> tree.

Is there any reason that this patch (copied below) cannot be applied to
the i7core_edac tree?

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 12 Nov 2009 16:55:38 +1100
Subject: [PATCH] i7core_edac: do not export static functions

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/pci/legacy.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 5e22d83..a8194c8 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -38,7 +38,6 @@ static int __init pci_legacy_init(void)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(pci_legacy_init);
 
 void pcibios_scan_specific_bus(int busn)
 {
-- 
1.6.5.2

