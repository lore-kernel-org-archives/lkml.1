Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbYJTIlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbYJTIlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 04:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbYJTIkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 04:40:52 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:15593 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbYJTIkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 04:40:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IVX6FFYrxZ2w3vH3yBlheiTO1VZY4NGmoYHxBmEaSF5fvB7yyg9DhQ9RblJwUuIAk1
         B0HWvImYsi6lGzrtU5Kc/EG27u139JTrTOfS98SQY0sR0fXk8P7HS7VB0K3kiiAPUH+H
         FxKTe8Oxs1i9z0tDDSpFau3ZbcVFviWp3Fdg8=
Message-ID: <2891419e0810200140s3cf9c0a3q228620519ae5f4af@mail.gmail.com>
Date: Mon, 20 Oct 2008 17:40:49 +0900
From: "Dong-Jae Kang" <baramsori72@gmail.com>
To: "Ryo Tsuruta" <ryov@valinux.co.jp>
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0: Introduction
Cc: agk@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       corsetproject@googlegroups.com
In-Reply-To: <20081017.160950.71109894.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081017.160950.71109894.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ryo Tsuruta

I am trying to install your new released dm-ioband v1.8.0
I/O bandwidth controller v1.8.0 could be adjusted to  the latest
stable kernel 2.6.27.1
it was good news for me
but, I had a problem when I try to patch bio-cgroup files to  stable
kernel 2.6.27.1
many patch failure and hunk messages were occured.

Can you check bio-cgroup patch files against stable kernel 2.6.27.1?

If the dm-ioband and bio-cgroup patches had different base kernel, i
think it is not natural.
I think it is more reasonable to release dm-ioband and bio-cgroup
patches in pair.
In my situation, both direct IO and buffered IO are same important.

thank you

Regard,
Dong-Jae Kang

2008/10/17 Ryo Tsuruta <ryov@valinux.co.jp>:
> Hi Alasdair and all,
>
> This is the dm-ioband version 1.8.0 release.
>
> Dm-ioband is an I/O bandwidth controller implemented as a device-mapper
> driver, which gives specified bandwidth to each job running on the same
> physical device.
>
> This release is a minor bug fix and confirmed running on the latest
> stable kernel 2.6.27.1.
>
> - Can be applied to the kernel 2.6.27.1 and 2.6.27-rc5-mm1.
> - Changes from 1.7.0 (posted on Oct 3, 2008):
>  - Fix a minor bug in io_limit setting that causes dm-ioband to stop
>    issuing I/O requests when a large value is set to io_limit.
>
> Alasdair, could you please review this patch and give me any comments?
>
> Thanks,
> Ryo Tsuruta
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
>



-- 
-------------------------------------------------------------------------------------------------
   DONG-JAE, KANG
   Senior Member of Engineering Staff
   Internet Platform Research Dept, S/W Content Research Lab
   Electronics and Telecommunications Research Institute(ETRI)
   138 Gajeongno, Yuseong-gu, Daejeon, 305-700 KOREA
   Phone : 82-42-860-1561 Fax : 82-42-860-6699
   Mobile : 82-10-9919-2353 E-mail : djkang@etri.re.kr (MSN)
-------------------------------------------------------------------------------------------------
