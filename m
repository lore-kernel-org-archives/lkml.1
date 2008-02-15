Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbYBORyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbYBORyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbYBORyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:54:20 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:56041 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbYBORyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:54:19 -0500
Message-ID: <47B5D1C3.40702@linux.vnet.ibm.com>
Date: Fri, 15 Feb 2008 23:24:11 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: bzolnier@gmail.com
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org, michael@ellerman.id.au,
       Andy Whitcroft <apw@shadowen.org>
Subject: [BUID_FAILURE] next-20080215 Build failure caused by ide: rework
 PowerMac media-bay support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linux-next-20080215 kernel build fails on the powerpc with
following error
 
  CC      arch/powerpc/platforms/powermac/setup.o
In file included from arch/powerpc/platforms/powermac/setup.c:66:
include/asm/mediabay.h:29: error: syntax error before 'ide_hwif_t'
include/asm/mediabay.h:29: warning: function declaration isn't a prototype
make[2]: *** [arch/powerpc/platforms/powermac/setup.o] Error 1
make[1]: *** [arch/powerpc/platforms/powermac] Error 2
make: *** [arch/powerpc/platforms] Error 2

This build failure is caused by the  ide: rework PowerMac media-bay support
patch.This problem was reported and solution suggested according to
http://lkml.org/lkml/2008/2/13/195 including the 

#include <linux/ide.h> after

#ifdef CONFIG_BLK_DEV_IDE_PMAC

helps in fixing the build failure.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
