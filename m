Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbZDFW1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbZDFW1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZDFW1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:27:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53176 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbZDFW1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:27:10 -0400
Message-ID: <49DA817E.8040705@intel.com>
Date: Mon, 06 Apr 2009 15:26:06 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
Organization: Intel Corporation
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Brian Maly <bmaly@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, dannf@hp.com,
       ying.huang@intel.com
Subject: Re: [PATCH] rtc: add x86 support for rtc-efi
References: <49DA40B9.2060804@redhat.com>
In-Reply-To: <49DA40B9.2060804@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Maly wrote:
> This patch adds support for rtc-efi (RTC Class Driver for EFI-based
> systems) to x86.
> 
> This patch is based on dann frazier patch [add rtc platform driver for
> EFI -> http://lkml.org/lkml/2009/1/8/434], and also depends on dann's
> patch. Dann's patch was in the mm tree, though I think its been merged
> already.
> 
> This patch has been tested and works perfectly on every x86 EFI system I
> could find, though all have been EL64 systems. I would appreciate any
> testing feedback from EL32 systems from anyone that has one and can test.
> 
> Signed-off-by: Brian Maly <bmaly@redhat.com>
> 
> 
> 
> 

-	depends on IA64
+	depends on IA64 || (X86 && EFI) || (X86_64 && EFI)

"depends on EFI"?

	-hpa
