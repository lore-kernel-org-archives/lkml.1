Return-Path: <linux-kernel-owner+w=401wt.eu-S1761342AbZEMTKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342AbZEMTKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759697AbZEMTKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:10:41 -0400
Received: from outbound-mail-19.bluehost.com ([69.89.20.234]:35006 "HELO
	outbound-mail-19.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759944AbZEMTKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:10:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pQcATK2AN8aveyJCuiocdxdK/pANLhXLXdErqnJjVqALKKnHq7joSMo3lCO9fHUKFIrxTAmk4ZR2hr3iwpAV/dLRkZXTHRobCbJcphwh2iK2Gkpt+0I+4vQISxTvIwRa;
Date: Wed, 13 May 2009 12:10:30 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [git pull] drm fix
Message-ID: <20090513121030.410f3ed4@jbarnes-g45>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
8c9ed899b44c19e81859fbb0e9d659fe2f8630fc: David Howells (1):
        NOMMU: Don't check vm_region::vm_start is page aligned in add_nommu_region()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/drm-2.6 for-linus

Jesse Barnes (1):
      drm/i915: automatically select FRAMEBUFFER_CONSOLE if !EMBEDDED

 drivers/gpu/drm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Just one fix so far for a common complaint.  I think Ben has an
important fix on the way soon too, but I haven't received it yet and
didn't want to lose this one.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
