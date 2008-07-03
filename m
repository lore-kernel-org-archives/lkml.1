Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbYGCMSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbYGCMSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbYGCMSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:18:06 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:54871 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751481AbYGCMSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:18:04 -0400
Date: Thu, 3 Jul 2008 16:52:33 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kernel-testers@vger.kernel.org, rusty@rustcorp.com.au, apw@shadowen.org
Subject: [BUILD-FAILURE] 2.6.26-rc8-mm1 - build failure at drivers/char/hvc_rtas.c
Message-ID: <20080703112233.GA6451@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080703020236.adaa51fa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

2.6.26-rc8-mm1 kernel build fail on the powerpc, 

In file included from drivers/char/hvc_rtas.c:39:
drivers/char/hvc_console.h:59: error: field ‘kref’ has incomplete type
make[2]: *** [drivers/char/hvc_rtas.o] Error 1
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2

this was already fixed by rusty (http://lkml.org/lkml/2008/6/27/21).

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
