Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbZC1OY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbZC1OY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 10:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZC1OYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 10:24:49 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:51019 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZC1OYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 10:24:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gFtSkRZyzRITRkABaAi3kFn3vPkxU+YVrW2zy7sAr6IFKWwp7Wdx+vNIyVVI1RUA9E
         vH/XB6x0N5+Flk/ERKc5kP1d5tLATZbaY/9AYlhaUzeG7e9Xz9jwki+SKUTiN5DmMyfI
         1xy8Hkk5uF36o5k2L9Kpy4EuF110O8H7ispI0=
MIME-Version: 1.0
In-Reply-To: <20090327212241.234500000@intel.com>
References: <20090327212241.234500000@intel.com>
Date: Sat, 28 Mar 2009 10:24:45 -0400
Message-ID: <cb0375e10903280724s22b231f8w81593c23ca90c288@mail.gmail.com>
Subject: Re: [patch 0/4] Intel IOMMU Supspend/Resume Support
From: Andrew Lutomirski <amluto@gmail.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       IOMMU <iommu@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Works for me (applied to current -tip).  I suspended and resumed just
fine, with no errors logged and all hardware apparently still working.

Tested-by: Andy Lutomirski <amluto@gmail.com>

Thanks for the patch!
Andy

On Fri, Mar 27, 2009 at 5:22 PM, Fenghua Yu <fenghua.yu@intel.com> wrote:
> Current Intel IOMMU does not support suspend and resume. In S3 event, kernel
> crashes when DMAR or interrupt remapping is running.
>
> The attached patch set implements the suspend and resume feature for Intel
> IOMMU. It hooks to kernel suspend and resume interface. When suspend happens, itsaves necessary hardware registers. When resume happens, it restores the
> registers and restarts IOMMU.
>
> This patch set can be applied on the tip tree.
>
> --
>
>
