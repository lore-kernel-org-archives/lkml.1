Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbYD2Ohp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbYD2Ohp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbYD2Ohe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:37:34 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49697 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYD2Ohd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:37:33 -0400
Message-Id: <20080429143304.741001000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 29 Apr 2008 16:33:04 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: [PATCH 00/10] Scalability requirements for sysv ipc - v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After scalability problems had been detected when using the sysV ipcs, I
have proposed to use an RCU based implementation of the IDR api instead
(see thread http://lkml.org/lkml/2008/4/11/212).

Resending the patch series after
 . integrating Paul's remarks
 . fixing a bug I had introduced
 . porting it to 2.6.25-mm1.

Reviewers are still welcome!

Patch 1 can be taken alone: it fixes a problem in the existing IDR API.

Patches should be applied on linux-2.6.25-mm1, in the following order:

[ PATCH 01/10 ] : idr_minor_fix.patch
[ PATCH 02/10 ] : ridr_structure.patch
[ PATCH 03/10 ] : ridr_pre_get.patch
[ PATCH 04/10 ] : ridr_init.patch
[ PATCH 05/10 ] : ridr_get_new_above.patch
[ PATCH 06/10 ] : ridr_get_new.patch
[ PATCH 07/10 ] : ridr_find.patch
[ PATCH 08/10 ] : ridr_remove.patch
[ PATCH 09/10 ] : ipc_use_ridr.patch
[ PATCH 10/10 ] : remove_ipc_lock_down.patch

Regards,
Nadia


--
