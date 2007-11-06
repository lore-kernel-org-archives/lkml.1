Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbXKFPz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbXKFPz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 10:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXKFPzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 10:55:19 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:43794 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXKFPzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 10:55:17 -0500
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded -
	build fails on powerpc
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <4730649E.2020405@linux.vnet.ibm.com>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
	 <4730649E.2020405@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 06 Nov 2007 07:56:22 -0800
Message-Id: <1194364582.25901.0.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-06 at 18:27 +0530, Kamalesh Babulal wrote:
> akpm@linux-foundation.org wrote:
> > powerpc-move-_rtc_time-routines-under-config_adb_cuda.patch
> 
>   CC      net/9p/error.o
> arch/powerpc/platforms/powermac/time.c:168: error: implicit declaration of function ‘from_rtc_time’
> arch/powerpc/platforms/powermac/time.c:225: error: implicit declaration of function ‘to_rtc_time’
> make[2]: *** [arch/powerpc/platforms/powermac/time.o] Error 1
> make[1]: *** [arch/powerpc/platforms/powermac] Error 2
> make: *** [arch/powerpc/platforms] Error 2
> 
> The above patch causes the build failure, because the from_rtc_time() and to_rtc_time() are
> moved under the ifdef CONFIG_ADB_CUDA, but they are begin called in the pmu_set_rtc_time() and
> pmac_get_rtc_time() under CONFIG_ADB_PMU.


Yes. My fault. This patch needs to be dropped. Sorry.

Thanks,
Badari

