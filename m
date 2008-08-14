Return-Path: <linux-kernel-owner+w=401wt.eu-S1759900AbYHNSrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbYHNSrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYHNSqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:46:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57043 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbYHNSqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject;
        b=Ghje17hx3JITPFiQ1pXGFrRPwBsPFFPZ0+cpScWtdtRsW4psuzqlsGkhyVu3GKaRHJ
         3Gu3TrDj5m3tFfSGPhf6osmPFkdj50YAIzSisZef9l+7jnDyp2z0tP54hCOAW/x7TPEJ
         1RbXuiTHNoEO5YTEn8mHWZIHTNBjXDq6o0cJE=
Message-Id: <20080814183428.550709025@gmail.com>
User-Agent: quilt/0.46-1
Date: Thu, 14 Aug 2008 22:34:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: macro@linux-mips.org, mingo@elte.hu, tglx@linutronix.de
Cc: hpa@zytor.com, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org
Subject: [patch 0/8] [RFC -tip] another one step toward APIC merging
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are the series of patches to help APIC code merging.
I've more patches in my queue (~20 for now). But I still playing
with them so they too much ugly to be even tested.

The patch with subject
	x86: apic - do not clear APIC twice in lapic_shutdown
actually is not merge-helper but rather I found a bit strange
of double clearing of APIC in 32bit code.

As always I would really appreciate any comments on this series.

The patches are over -tip/master

commit 8f87590f7c4a2164ab6330711c9a33ab59f97e25
Merge: fb71068... c2fc119...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Aug 12 11:22:08 2008 +0200

    Merge branch 'core/urgent'

		- Cyrill -
-- 
