Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYAIKLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYAIKLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYAIKLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:11:12 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44691 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYAIKLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:11:11 -0500
Date: Wed, 9 Jan 2008 15:44:04 +0530
From: Sudhir Kumar <skumar@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Build Fails on 2.6.24-rc6-mm1[drivers/net/iseries_veth.ko] linking error
Message-ID: <20080109101404.GC1321@in.ibm.com>
Reply-To: skumar@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
Build fails on my Power Machine with following error message.


 HOSTLD  arch/powerpc/boot/dtc
 WRAP    arch/powerpc/boot/zImage.pseries
 WRAP    arch/powerpc/boot/zImage.pmac
strip -s -R .comment vmlinux -o arch/powerpc/boot/zImage.iseries
 Building modules, stage 2.
 MODPOST 264 modules
ERROR: ".driver_add_kobj" [drivers/net/iseries_veth.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Thanks and Regards,
Sudhir Kumar
