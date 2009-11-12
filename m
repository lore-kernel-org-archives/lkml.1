Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbZKLUxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbZKLUxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:53:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZKLUxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:53:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:63585 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbZKLUxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:53:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jY+EVB11Ju8r72ln6UeLVx5KuodK/sOzAFoweyPhsjlSITZg+yB/WD3AS/DWAm7oR8
         gglS2qKEaP86+ipKMueqB44+qT5lk68L0juCLyxum1FSKe9af4kGRoLt/4PBxJPJd75v
         T3Gtv1pcpaOOSA/caGtl+tsnogGS1bNAuKUc8=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Hiroshi Doyu <hiroshi.doyu@nokia.com>,
       Hari Kanigeri <h-kanigeri2@ti.com>,
       Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v3] omap3-iommu: reorganize
Date: Thu, 12 Nov 2009 22:52:59 +0200
Message-Id: <1258059180-4353-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third version of my attempt to reorganize the omap3 iommu code to
make it easier to read and more extensible. I've taken into consideration
Russell and Hiroshi's comments. Also, rebased on top of Tony's 'for-next'
branch, although no changes have been done since v2.

I'm resending because Tony asked me to.

Felipe Contreras (1):
  omap3-iommu: reorganize

 arch/arm/mach-omap2/omap3-iommu.c |   62 ++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 31 deletions(-)

