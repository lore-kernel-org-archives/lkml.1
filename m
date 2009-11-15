Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbZKOKRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbZKOKRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZKOKRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:17:32 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:35705 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZKOKRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:17:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=lLC02/fkTnnkwX+ojVlZ9XOV3pCwXqHnnH8sPycmVnWKXGK4FbiRSmChq/LkmiB7s8
         Td/a4pcGFaMGAfv/yTBNKxQm8zdubAc/l7WNbeMBoQ7nw44ZqK8bhPeZ+LxiLarYbDTn
         FcKfmAuDXMMvK1FyT3tMOGbs8GGO0WhvQAtPE=
From: Michael <schnitzelkuchen@googlemail.com>
Reply-To: schnitzelkuchen@googlemail.com
To: David Woodhouse <david.woodhouse@intel.com>
Subject: Re: [regression] [drm:i915_gem_execbuffer] *ERROR* Execbuf while wedged
Date: Sun, 15 Nov 2009 11:17:33 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.31; KDE/4.3.3; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>
References: <200911151048.13777.schnitzelkuchen@googlemail.com> <1258278948.1496.155.camel@macbook.infradead.org>
In-Reply-To: <1258278948.1496.155.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911151117.34094.schnitzelkuchen@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 15 November 2009 10:55:48 schrieb David Woodhouse:
> On Sun, 2009-11-15 at 01:48 -0800, Michael wrote:
> > I tried 2.6.32-rc6 with my Dell Inspiron 1525, but the KDM didnt
> > display right - It was mostly black with only the cursor displayed.
> > Other things which use X dont work with the kernel, too.
> 
> Interesting. Do you actually have an IOMMU, and is it enabled?
> 

Well, my CPU is a "Intel(R) Core(TM)2 Duo CPU     T5750  @ 2.00GHz", which 
doesnt even have Intel VT, so i guess i dont have an IOMMU.

My .config for the test kernel says the following:

brotscheibe linux-2.6 # grep IOMM .config
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set


I hope that helps,
Michael
