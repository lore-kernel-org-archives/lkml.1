Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbYDGOHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbYDGOHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 10:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYDGOHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 10:07:30 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:22362 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYDGOH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 10:07:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A7Yu58KGHCtXgD4mfjRgjJkpOZ3o2KEPSK3MpZrHNHgrm6h4pRLEmZfUIgPQ+/g1G/LjmGDbnlN04rlCaXI90SeSNJb9GbBL/FEqPweC0XGjpxGd10baUw+ZJ0SQvwdhYb86qgi9lo4M/BG+NxfxfxGCVRQuZfKYHhHeculdS2U=
Message-ID: <36ca99e90804070707g41d374a5m9b80e77165534f1b@mail.gmail.com>
Date: Mon, 7 Apr 2008 16:07:28 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH 0/4] x86: add cpus_scnprintf function v2
Cc: "Mike Travis" <travis@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080407030421.0c3f8033.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080405012447.440875000@polaris-admin.engr.sgi.com>
	 <20080407030421.0c3f8033.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2008 at 10:04 AM, Paul Jackson <pj@sgi.com> wrote:
> I still have some concerns with this cpus_scnprintf patch.
>
>  I've taken them up with Mike offline for initial consideration.
>
>  If others have questions, concerns or enthusiasms for this patch,
>  Mike and I would be interested.
As long as the only justification for this cpus_scnprintf is human
readability, I have concerns too.

Patch 2/4 itself is ok and 4/4 too. The only thing I miss is an export
of NR_CPUS. So that you know in front of reading a kernel mask, what
size your bitmap needs. (for example glibc cpu_set_t has only 1024
bits but has an cpu_set_t with arbitrary size too).

Bert
