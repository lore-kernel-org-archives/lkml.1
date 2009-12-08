Return-Path: <linux-kernel-owner+w=401wt.eu-S965235AbZLHBCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965235AbZLHBCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 20:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935731AbZLHBCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 20:02:19 -0500
Received: from mail-vw0-f197.google.com ([209.85.212.197]:32966 "EHLO
	mail-vw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935730AbZLHBCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 20:02:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=B+T43OBFv2F/8QAECAfA4FUWcjvBRjIG6Bp4PRYLitS9qf+1BOMTDODGvHxWtLGwuc
         k4pXc8rCuiDYYUUT+iLchpLBHlcdHkH1Yw46vTloYk6Ti9XDiNy2ZqkQqhkuGECIW8yJ
         NcFEc05hsmdLK3DndCDYTZKiaJddPG+yo4Eo8=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0912041942330.3981@axis700.grange>
References: <Pine.LNX.4.64.0912041936541.3981@axis700.grange>
	 <Pine.LNX.4.64.0912041942330.3981@axis700.grange>
Date: Mon, 7 Dec 2009 18:02:24 -0700
X-Google-Sender-Auth: 4d36f50e8c14c4f0
Message-ID: <e9c3a7c20912071702h1aea2026kff22db99a221f6c4@mail.gmail.com>
Subject: Re: [PATCH 5/5] sh: dmaengine support for sh7724
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>,
       Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 4, 2009 at 11:45 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Add a dmaengine platform device to sh7724, fix DMA channel interrupt numbers.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> With this patch dmatest works with channels 0-5, channels 6-11 still don't
> work for some reason... So, feel free to discard it for now, if a complete
> fix would be preferred.

Does this patch limit operation to channels 0-5?  I leave this one for
Paul to disposition.

Thanks,
Dan
