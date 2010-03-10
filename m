Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab0CJPms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:42:48 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:27705 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab0CJPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:42:47 -0500
X-IronPort-AV: E=Sophos;i="4.49,614,1262563200"; 
   d="scan'208";a="9880197"
Date: Wed, 10 Mar 2010 15:46:54 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0 of 5] PV on HVM Xen
Message-ID: <alpine.DEB.2.00.1003101457100.28412@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this is a reduced and rebased version of the patch series I sent
yesterday "enhanced PV on HVM": this series is based on Linux 2.5.32 and
can be applied now, it includes everything but the pirq remapping
related functions that are not ready to be upstreamed at the moment.

Therefore it just achieves the goal of enabling PV devices in Linux
running in a Xen HVM domain, it doesn't allow event channels delivery in
place of interrupts.

The patch series consists of 5 patches, each patch comes with a detailed
description.
In order for this to work we also need a patch for Xen, that is being
worked on as we speak.

Any comment, critic or suggestion is very welcome.

Cheers,

Stefano
