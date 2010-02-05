Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030Ab0BEW6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 17:58:21 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:35508 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950Ab0BEW6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:58:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=uNRm82iDQGlKqK4uFUadXDgPfdR89OMWp1H2MSRAf7Pzszh2f0nn3NDuZoHDokJC5a
         178grPimufAurMSr8/qX9PPl0YVonQxRZuIMcADg5o+n/Pk/32VubL12G0KTmaenmSCW
         l6GLB2fOQY4ECWPgdFn0QhSSR8ay6i6w2t8Ww=
MIME-Version: 1.0
In-Reply-To: <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
References: <1265377920-5898-1-git-send-email-yong.zhang0@gmail.com>
	 <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
Date: Fri, 5 Feb 2010 15:58:18 -0700
X-Google-Sender-Auth: caef3556a9c78edb
Message-ID: <e9c3a7c21002051458p6517370i1bae6d2ab64ededc@mail.gmail.com>
Subject: Re: [PATCH 1/4] dmaengine: correct onstack wait_queue_head 
	declaration
From: Dan Williams <dan.j.williams@intel.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 6:52 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> Use DECLARE_WAIT_QUEUE_HEAD_ONSTACK to make lockdep happy
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Thanks, applied and pushed back out on async_tx.git#fixes.
