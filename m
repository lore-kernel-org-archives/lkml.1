Return-Path: <linux-kernel-owner+w=401wt.eu-S1758992AbXKUIZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992AbXKUIZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 03:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbXKUIZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 03:25:03 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:59207 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753303AbXKUIZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 03:25:00 -0500
Message-ID: <4743EB52.1040205@linux.vnet.ibm.com>
Date: Wed, 21 Nov 2007 13:54:50 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc3-mm1 make headers_check fails
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
In-Reply-To: <20071120204525.ff27ac98.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The make headers_check fails,

  CHECK   include/linux/usb/gadgetfs.h
  CHECK   include/linux/usb/ch9.h
  CHECK   include/linux/usb/cdc.h
  CHECK   include/linux/usb/audio.h
  CHECK   include/linux/kvm.h
/root/kernels/linux-2.6.24-rc3/usr/include/linux/kvm.h requires asm/kvm.h, which does not exist in exported headers
make[2]: *** [/root/kernels/linux-2.6.24-rc3/usr/include/linux/.check.kvm.h] Error 1
make[1]: *** [linux] Error 2
make: *** [headers_check] Error 2


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
