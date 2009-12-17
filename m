Return-Path: <linux-kernel-owner+w=401wt.eu-S934516AbZLQNFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934516AbZLQNFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 08:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934185AbZLQNFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 08:05:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933910AbZLQNFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 08:05:13 -0500
Date: Thu, 17 Dec 2009 15:01:46 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Xiantao Zhang <xiantao.zhang@intel.com>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       kvm@vger.kernel.org, kvm-ia64@vger.kernel.org,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm-ppc@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH-cc-fixed] vhost: add missing architectures
Message-ID: <20091217130146.GA26726@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vhost is completely portable, but Kconfig include was missing for all
architectures besides x86, so it did not appear in the menu.  Add the
relevant Kconfig includes to all architectures that support
virtualization.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Some IBM addresses seem to be bouncing. Reposting with these removed,
please send replies to this shorter list to avoid bounces.  Sorry about
the noise.


Hi Rusty,
please apply the following trivial fixup patch for 2.6.33.
Thanks!

 arch/ia64/kvm/Kconfig    |    1 +
 arch/powerpc/kvm/Kconfig |    1 +
 arch/s390/kvm/Kconfig    |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index ef3e7be..01c7579 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -47,6 +47,7 @@ config KVM_INTEL
 	  Provides support for KVM on Itanium 2 processors equipped with the VT
 	  extensions.
 
+source drivers/vhost/Kconfig
 source drivers/virtio/Kconfig
 
 endif # VIRTUALIZATION
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index c299268..a1b4c5d 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -58,6 +58,7 @@ config KVM_E500
 
 	  If unsure, say N.
 
+source drivers/vhost/Kconfig
 source drivers/virtio/Kconfig
 
 endif # VIRTUALIZATION
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index bf164fc..6be6aea 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -36,6 +36,7 @@ config KVM
 
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
+source drivers/vhost/Kconfig
 source drivers/virtio/Kconfig
 
 endif # VIRTUALIZATION
-- 
1.6.6.rc1.43.gf55cc
