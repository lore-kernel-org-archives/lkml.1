Return-Path: <linux-kernel-owner+w=401wt.eu-S1761351AbZLLE6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761351AbZLLE6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 23:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761235AbZLLE6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 23:58:30 -0500
Received: from mail-vw0-f197.google.com ([209.85.212.197]:65353 "EHLO
	mail-vw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761218AbZLLE63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 23:58:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Y2kxzTgVcNun+vBCeiovrW2rhiOUJLC73sA/C6O7E5vuyymRnFGqIcLELPw1rm8Yt5
         m2wo+KKF4c2awzVQWRujRzrbM/uFzMJJy2QxTgbRlWA6zKVpwcONFLjPNPJbLkdbYBx5
         a87NT6PXKIKmlLu0t4nhVyQCdpRkDryHzxYeA=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0912101826010.4487@axis700.grange>
References: <Pine.LNX.4.64.0912101826010.4487@axis700.grange>
Date: Fri, 11 Dec 2009 21:58:34 -0700
X-Google-Sender-Auth: 0cd758e2834b0024
Message-ID: <e9c3a7c20912112058ga8427c8qc411c3b067cd1751@mail.gmail.com>
Subject: Re: [PATCH 0/3 v2] sh: fix dma driver
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 10:35 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Further testing with preempt enabled revealed more problems with
> insufficient locking and improper descriptor state management. Therefore
> I'm resubmitting the
>
> sh: fix DMA driver's descriptor chaining and cookie assignment
>
> patch. At the same time I swapped it with stylistic changes, to put the
> complex stuff in the end. Also added a minor patch fixing comment in
> dmaengine.h. Patches
>
> sh: DMA driver has to specify its alignment requirements
> dmaengine: fix dmatest to verify minimum transfer length and test buffer size
> sh: dmaengine support for sh7724
>
> are not changed, so, not resubmitted

Applied:
      sh: DMA driver has to specify its alignment requirements
      dmaengine: fix dmatest to verify minimum transfer length and
test buffer size
      sh: stylistic improvements for the DMA driver
      dmaengine: clarify the meaning of the DMA_CTRL_ACK flag

Waiting for Nobuhiro's ack on:
      sh: fix DMA driver's descriptor chaining and cookie assignment
      sh: dmaengine support for sh7724

Thanks,
Dan
