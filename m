Return-Path: <linux-kernel-owner+w=401wt.eu-S932531AbYEGIVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbYEGIVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYEGIVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:21:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:8556 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYEGIV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OcUmZXWBfCPvDGhFAnKkvFfR7ayxCKlnFhta8XBeloxw94Zh8KVDgDtrjYOw2Ize+co6dxpUj9sOVRz8wOPQ2dug/ENyx0AKgpk11f8853Qdg22ayix+LZRBeunT3GdRTmgn5RwPAvAG3+OCkzVVIkP040R7PKlehvEyHr+KOTY=
Message-ID: <ce0170d90805070121r649e5dc1l301c55d45709c5df@mail.gmail.com>
Date: Wed, 7 May 2008 05:21:27 -0300
From: "Sergio Luis" <sergio@uece.br>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: audio skipping on 2.6.26-rc1
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
In-Reply-To: <E1JteVx-0003ro-2h@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1JteVx-0003ro-2h@pomaz-ex.szeredi.hu>
X-Google-Sender-Auth: 5bafef164a7627ff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 4:56 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On a T60 I get occasional (but very annoying) audio skips while
>  compiling kernels.  No kernels (as long as I remeber) prior to this
>  had any similar problems.
>
>  It's reproducible, but takes some minutes to get reliably.  Please
>  don't tell me to bisect it :)
>
>  Config attached.
>
>  Thanks,
>  Miklos
>

[...]

>  CONFIG_GROUP_SCHED=y
>  CONFIG_FAIR_GROUP_SCHED=y

try disabling these, as the following thread suggests:
http://marc.info/?l=linux-kernel&m=120986180600392&w=2

-sergio
