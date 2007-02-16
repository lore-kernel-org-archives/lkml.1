Return-Path: <linux-kernel-owner+w=401wt.eu-S932490AbXBPROX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbXBPROX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbXBPROW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:14:22 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53726 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490AbXBPROW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:14:22 -0500
Subject: Re: 2.6.20-mm1 - undefined reference to `delete_module' on x86
From: Steve Fox <drfickle@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 11:14:17 -0600
Message-Id: <1171646057.3039.10.camel@drfickle.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Full log at
http://test.kernel.org/abat/71719/debug/test.log.0
Config at
http://test.kernel.org/abat/71719/build/dotconfig

  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
kernel/built-in.o(.text+0x1426a): In function `store_mod_unload':
kernel/kmod.c:168: undefined reference to `delete_module'
make: *** [.tmp_vmlinux1] Error 1

-- 

Steve Fox
IBM Linux Technology Center

