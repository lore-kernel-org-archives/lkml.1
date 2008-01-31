Return-Path: <linux-kernel-owner+w=401wt.eu-S1765002AbYAaDgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765002AbYAaDgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 22:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYAaDgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 22:36:36 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:61956 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbYAaDgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 22:36:35 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/6] Move include/asm-ppc/rio.h to include/asm-powerpc/rio.h
Date: Thu, 31 Jan 2008 11:36:19 +0800
Message-ID: <ABF87B0B6A38C0458E319AC973ED68AEBD0612@zch01exm26.fsl.freescale.net>
In-Reply-To: <AF5092BE-3384-44F8-A104-560DD4331726@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/6] Move include/asm-ppc/rio.h to include/asm-powerpc/rio.h
Thread-Index: AchjS2YGoP25s/v7QXKCa+9ILf3MlgAbqscg
References: <1201689053956-git-send-email-wei.zhang@freescale.com> <12016890621727-git-send-email-wei.zhang@freescale.com> <120168907160-git-send-email-wei.zhang@freescale.com> <AF5092BE-3384-44F8-A104-560DD4331726@kernel.crashing.org>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Cc: <mporter@kernel.crashing.org>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org] 
> On Jan 30, 2008, at 4:30 AM, Zhang Wei wrote:
> 
> > Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
> > ---
> > include/asm-powerpc/rio.h |   18 ++++++++++++++++++
> > include/asm-ppc/rio.h     |   18 ------------------
> > 2 files changed, 18 insertions(+), 18 deletions(-)
> > create mode 100644 include/asm-powerpc/rio.h
> > delete mode 100644 include/asm-ppc/rio.h
> 
> it seems with OF we can just git rid of this?
> 

Aha, yep :), The change just make the RIO driver in arch/powerpc can be
compiled with RapidIO OF patch.

If we have OF patch, you can drop this patch.

Thanks!
Wei.
