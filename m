Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550Ab0BDR2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:28:54 -0500
Received: from kroah.org ([198.145.64.141]:34856 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933313Ab0BDRWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:13 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:16 2010
Message-Id: <20100204171516.470798586@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andi Kleen <ak@linux.intel.com>,
       Robert Richter <robert.richter@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [50/74] oprofile/x86: add Xeon 7500 series support
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andi Kleen <andi@firstfloor.org>

commit e83e452b0692c9c13372540deb88a77d4ae2553d upstream.

Add Xeon 7500 series support to oprofile.

Straight forward: it's the same as Core i7, so just detect
the model number. No user space changes needed.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -598,6 +598,7 @@ static int __init ppro_init(char **cpu_type)
 	case 15: case 23:
 		*cpu_type = "i386/core_2";
 		break;
+	case 0x2e:
 	case 26:
 		spec = &op_arch_perfmon_spec;
 		*cpu_type = "i386/core_i7";


