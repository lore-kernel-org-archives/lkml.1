Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZCYUxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZCYUxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZCYUx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:53:26 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51070 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbZCYUxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UKQCq3TMHWmFeXGUtCbF/zZ2ryu+SVFCdY+AZutUMmM6bTDobVW4kmpaKavBouNFc1
         e5VBmyPVQVgnX4L/+++wJBfJmldfgm+xB4SdxAiwy8HrvOD4kKjxFj6wlORRotTdQfFX
         EP0vn2jOFRGrQChEzVtrf7XsZaKljPZR4obj8=
MIME-Version: 1.0
In-Reply-To: <20090325184548.012018000@intel.com>
References: <20090325184548.012018000@intel.com>
Date: Wed, 25 Mar 2009 16:53:22 -0400
Message-ID: <cb0375e10903251353r367294d1ra00226e030594a32@mail.gmail.com>
Subject: Re: [patch 0/2] Intel IOMMU Suspend/Resume Support
From: Andrew Lutomirski <amluto@gmail.com>
To: fenghua.yu@intel.com
Cc: mingo@elte.hu, dwmw2@infradead.org, kyle@redhat.com,
       mgross@linux.intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like patch 1 calls dmar_reenable_qi but patch 2 defines it.

In 2.6.29, there's no dmar_disable_qi that I can see.  Can you respin
these against something a little less scary than -tip during a merge
window?  (Especially since -stable will need this soon.)

Thanks,
Andy

On Wed, Mar 25, 2009 at 2:45 PM,  <fenghua.yu@intel.com> wrote:
> Current Intel IOMMU does not support suspend and resume. In S3 event, kernel
> crashes when IOMMU is enabled. The attached patch set implements the suspend and
> resume feature for Intel IOMMU. It hooks to kernel suspend and resume interface.
> When suspend happens, it saves necessary hardware registers. When resume happens
> it restores the registers and restarts IOMMU.
>
> This patch set is applied to the tip tree.
>
> --
>
>
