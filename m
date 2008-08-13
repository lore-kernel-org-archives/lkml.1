Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbYHMU4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbYHMU4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbYHMU4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:56:13 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:32775 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbYHMU4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:56:12 -0400
From: York Sun <yorksun@freescale.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       galak@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 0/2] Add virtual resolution and panning for Freescale DIU
Date: Wed, 13 Aug 2008 15:55:02 -0500
Message-Id: <12186609042933-git-send-email-yorksun@freescale.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set adds virtual resolutoin suppport for Freescale DIU driver.
Applications such as fbset can set visible resolution and virtual resoltuion.
X window can use the virtual resolution if xorg.conf has the following option.

option virtual <vxres> <vyres>


The second patch fixes a bug of AOI position.

Regards,

York

