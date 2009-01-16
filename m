Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbZAPIVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbZAPIVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZAPIV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:21:29 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:33743 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZAPIV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:21:28 -0500
Date: Fri, 16 Jan 2009 03:21:26 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: 2.6.29-rc1 vs selinux
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200901160321.26749.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the things that was bugging me was that after having booted 2.6.29-rc1, 
rebooting to 2.6.28 final always caused an automatic relabel, which on this 
box with a bit over a terrabyte in drives, takes an extra 20 minutes to do.

So I grepped the .config's and there is no mention of SELINUX in the output of 
a make oldconfig for 2.6.29-rc1, based on a 2.6.28 .config input.

I see the security/selinux directory still exists in the src tree.  Is this a 
kconfig bug, or is selinux outta here?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Bushydo -- the way of the shrub.  Bonsai!
