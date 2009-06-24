Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbZFXUiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbZFXUiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759784AbZFXUhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:37:54 -0400
Received: from mga10.intel.com ([192.55.52.92]:32628 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753948AbZFXUhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:37:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,285,1243839600"; 
   d="scan'208";a="702223896"
Message-ID: <4A428E9D.7080509@linux.intel.com>
Date: Wed, 24 Jun 2009 13:37:49 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Joseph Cihula <joseph.cihula@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v5][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution	Technology
 support for Linux - Details
References: <4A4024B6.2060600@intel.com> <20090624201415.GA18291@redhat.com>
In-Reply-To: <20090624201415.GA18291@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Mon, Jun 22, 2009 at 05:41:26PM -0700, Joseph Cihula wrote:
>  
>  > The Q35_SINIT_17.BIN file is what Intel TXT refers to as an
>  > Authenticated Code Module.  It is specific to the chipset in the system
>  > and can also be found on the Trusted Boot site.  It is a firmware module
>  > digitally signed by Intel that is used as part of the DRTM process to
>  > verify and configure the system.  
> 
> This seems a little disingenious.  Firmware isn't typically loaded by grub
> into main memory and executed by the host processor.
> 
> so, is this all worthless without the binary blob ?
> 
> "trust us, it's signed by intel" doesn't make me feel more secure.

how's that different from your normal bios ?
