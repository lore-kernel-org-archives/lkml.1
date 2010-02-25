Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab0BYTwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:52:17 -0500
Received: from smtp.citrix.com ([66.165.176.89]:32537 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933028Ab0BYTwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:52:16 -0500
X-IronPort-AV: E=Sophos;i="4.49,541,1262581200"; 
   d="scan'208";a="7359334"
Subject: VMI and kmap_atomic_pte paravirt_op
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Alok N Kataria <akataria@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Thu, 25 Feb 2010 19:52:12 +0000
Message-ID: <1267127532.2488.7.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alok,

How critical is the vmi_kmap_atomic_pte pv_mmu_op hook to VMI? Is it
required for correct functionality or is it simply an optimisation?

We think we may be able to do away with the Xen version of the hook and
if VMI (which is deprecated) can live without it and you agree then I'll
cook up a patch to remove it altogether.

Thanks,
Ian.


