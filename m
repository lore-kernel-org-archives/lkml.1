Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbYHNIfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbYHNIfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 04:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYHNIfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:35:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:53355 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbYHNIfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:35:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=KrPxrfdrGCA4m1bFmaT1jBJrfFTUehHsqBNwuIRBJlbRmNxeN9MrlTptFta0W0VlF4
         R4V/UckKeatInDSqNmrvLTsXiMr0mVEZuJrPA7UD2Bg9Rz3+F9NniGPoN1BHepvd5uat
         I7qkqn9spepEkZ1wGxmf0vKT/6ztPZObcdWPU=
Message-ID: <804dabb00808140135i49386d4v5513aafaa31d6d9d@mail.gmail.com>
Date: Thu, 14 Aug 2008 16:35:11 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: KDB compilation errors for 2.6.26
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I patched the stock kernel at
http://www.kernel.org/pub/linux/kernel/v2.6/ for 2.6.26 with the two
kdb for 2.6.26 from

ftp://oss.sgi.com/www/projects/kdb/download/latest/

and after compilation,

  CHECK   include/video/uvesafb.h
  CHECK   include/video/sisfb.h
  CHECK   include/video/edid.h
Kernel: arch/x86/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 1605 modules
ERROR: "next_online_pgdat" [kdb/modules/kdbm_vm.ko] undefined!
ERROR: "first_online_pgdat" [kdb/modules/kdbm_vm.ko] undefined!
WARNING: modpost: Found 7 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Not sure how you would like to resolve that, as kdbm_vm.c does not
seem to use the symbol.   Thanks.

-- 
Regards,
Peter Teoh
