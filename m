Return-Path: <linux-kernel-owner+w=401wt.eu-S1760497AbYE2U2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbYE2U2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759225AbYE2UZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:25:26 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:46019 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780AbYE2UZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:25:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LGrWa8HS+lqEV6JhjtyNPts8PnuylHc11Qxc4ZIoXPgdtbfOSYPYIJ8tHq1Azz5HVRteY+q+9EjM4yI/Nzeb+rBEsk+VKPpI3ycWi2NrOaYIuKuV7aAytc4m85FMU3Ge7bcqqQGyGfKLfRZKe/SSRcNimQet0+S44gwUNq2ux6M=
Message-ID: <8bd0f97a0805291325w7d435e89h4de614547fb1bc7f@mail.gmail.com>
Date: Thu, 29 May 2008 16:25:14 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Pekka J Enberg" <penberg@cs.helsinki.fi>, mpm@selenic.com,
       lethal@linux-sh.org, linux-kernel@vger.kernel.org,
       "Bryan Wu" <cooloney@kernel.org>
In-Reply-To: <29553.1212066208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2874.1211980355@redhat.com>
	 <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
	 <24762.1211983758@redhat.com>
	 <Pine.LNX.4.64.0805281026210.22589@schroedinger.engr.sgi.com>
	 <7613.1211996335@redhat.com>
	 <8bd0f97a0805281335q7a26be97ie83feef6e7da2276@mail.gmail.com>
	 <29553.1212066208@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 9:03 AM, David Howells wrote:
> Mike Frysinger <vapier.adi@gmail.com> wrote:
>> > I fixed it by setting ARCH_KMALLOC_MINALIGN and ARCH_SLAB_MINALIGN.
>>
>> what was the change exactly ?
>
> The attached patch.
>
> diff --git a/include/asm-frv/mem-layout.h b/include/asm-frv/mem-layout.h
> +#define        ARCH_KMALLOC_MINALIGN           8
> +#define        ARCH_SLAB_MINALIGN              8

yeah, we were already doing that ... and the problem we had that i
referred to seems to be merged already into mainline, so you shouldnt
run into it unless you're using older kernel versions
-mike
