Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbZDFQGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbZDFQGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZDFQG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:06:26 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:54407 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZDFQGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iwF7VimCErAV7B3ZuT6nbly/QCOzZ1SCoyQei9znYpak064xEEfw1Lfxz2AMUiGtTn
         u6QvHzvQsNr9RFFvhFGsnSk66ypfHsZCMUnmjO7Lx4JaK1iewf1Fj6JhfZRBcHz/ppAS
         lDhegGUuWTLGklme4j79NJ83HHQLct30E4jtU=
MIME-Version: 1.0
In-Reply-To: <49D9CF13.60202@in.ibm.com>
References: <20090406164555.e1232116.sfr@canb.auug.org.au>
	 <49D9CF13.60202@in.ibm.com>
Date: Mon, 6 Apr 2009 20:06:21 +0400
Message-ID: <a4423d670904060906l339a987bm8cb0543d309ecac3@mail.gmail.com>
Subject: Re: Next April 6 : x86 allmodconfig failure [drivers/pci]
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Sachin Sant <sachinp@in.ibm.com>,
       David Woodhouse <david.woodhouse@intel.com>,
       Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/6 Sachin Sant <sachinp@in.ibm.com>:
> Today's next tree allmodconfig build on x86 failed with
>
> drivers/pci/intel-iommu.c:2636:35: error: macro "if" passed 2 arguments, but
> takes just 1
> drivers/pci/intel-iommu.c: In function init_iommu_hw:
> drivers/pci/intel-iommu.c:2636: error: expected ( before { token
> drivers/pci/intel-iommu.c:2637: error: ______r undeclared (first use in this
> function)
> drivers/pci/intel-iommu.c:2637: error: (Each undeclared identifier is
> reported only once
> drivers/pci/intel-iommu.c:2637: error: for each function it appears in.)
> drivers/pci/intel-iommu.c:2640:35: error: macro "if" passed 2 arguments, but
> takes just 1
> drivers/pci/intel-iommu.c:2640: error: expected ( before { token
>
> and many more of such errors. Similar errors with intr_remapping.c
>
> drivers/pci/intr_remapping.c:679:28: error: macro "if" passed 2 arguments,
> but takes just 1
> drivers/pci/intr_remapping.c: In function disable_intr_remapping:
> drivers/pci/intr_remapping.c:679: error: expected ( before { token
> drivers/pci/intr_remapping.c:693:28: error: macro "if" passed 2 arguments,
> but takes just 1
> ......

CC'ed David and Ingo.

commit 8f912ba4d

if (i=drhd->iommu, 0)

looks strange
