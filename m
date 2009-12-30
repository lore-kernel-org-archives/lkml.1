Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbZL3Rfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbZL3Rfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 12:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZL3Rf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 12:35:29 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:54470 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZL3Rf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 12:35:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=r+1Wzr4tcmuz8vSZhkII29eiFr7mtCxJwpb+GU/oY1FSB2gK2gf+hBc0VJsvRMqlcl
         Vtc/VVAfFS8fLWS2lzR98zo32OWeWYMfw4ji88Y5SnYA61Lqpsi4hbm3pxSwP4MdxBxC
         avi+RCzcZ8rwxywZogimQdUYo1rWkjevwVaik=
Message-ID: <4B3B8F5A.9050601@panasas.com>
Date: Wed, 30 Dec 2009 19:35:22 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: build error with DEBUG_STRICT_USER_COPY_CHECKS on at mm/migrate.c:1009
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan hi

building with ARCH=i386 allmodconfig will give me the below compilation error.
I'm on FC12 [gcc (GCC) 4.4.2 20091222 (Red Hat 4.4.2-20)]

In file included from arch/x86/include/asm/uaccess.h:571,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:6,
                 from include/linux/pagemap.h:10,
                 from include/linux/mempolicy.h:62,
                 from include/linux/migrate.h:5,
                 from mm/migrate.c:15:
In function 'copy_from_user',
    inlined from 'do_pages_stat' at mm/migrate.c:1009:
arch/x86/include/asm/uaccess_32.h:213: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct

un-setting DEBUG_STRICT_USER_COPY_CHECKS, (It was turned on by allmodconfig) will let
the kernel compile.

I thought you might want to know
Boaz

