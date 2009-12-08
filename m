Return-Path: <linux-kernel-owner+w=401wt.eu-S965325AbZLHAyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965325AbZLHAyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965310AbZLHAyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:54:12 -0500
Received: from mail-vw0-f197.google.com ([209.85.212.197]:65364 "EHLO
	mail-vw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965308AbZLHAyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:54:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GVXNEO1c6xhJOUSu0+FWbAEEAKkUbUy4euVNzwhlwK/5aavmCuWmHdUqy6WfQ5OOzq
         DAdO9CDnKybJ03peqchmvyT+h0ecCXHFdba+ell1eSsGPzr+HVT5NGgFUdTdeSbd1fiy
         yJZJIe48sBXRJ1+dly/ey3hX7iIr4OFRVq2G0=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0912041942040.3981@axis700.grange>
References: <Pine.LNX.4.64.0912041936541.3981@axis700.grange>
	 <Pine.LNX.4.64.0912041942040.3981@axis700.grange>
Date: Mon, 7 Dec 2009 17:54:17 -0700
X-Google-Sender-Auth: 2af74597d726e41a
Message-ID: <e9c3a7c20912071654y19313fd5j6d9ff5a62cde028e@mail.gmail.com>
Subject: Re: [PATCH 4/5] sh: stylistic improvements for the DMA driver
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 4, 2009 at 11:45 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/dma/shdma.c |   34 +++++++++++++++++-----------------
>  drivers/dma/shdma.h |   14 +++++++-------
>  2 files changed, 24 insertions(+), 24 deletions(-)
>
[..]
> -static int dmae_is_idle(struct sh_dmae_chan *sh_chan)
> +static int dmae_is_busy(struct sh_dmae_chan *sh_chan)

This one isn't purely style, I agree with it, but think it would be a
bit cleaner to return a bool rather than an error code.

--
Dan
