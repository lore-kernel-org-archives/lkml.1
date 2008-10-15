Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbYJOID3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbYJOID3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 04:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbYJOIDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 04:03:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:49572 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYJOIDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 04:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=io70Cb8R6t+1USnPMI9aghKA1Tlg8dIi/XZB1w4Deb1FTx0Xb+JLmlruvcjOaVFSP9
         xx/IBEqx/NH4nF8n3w/PhkUwYdSD6+PBOnozjUroWFlZ+Mz0iG519IEdBtckC2mTkckB
         YjJxvoqGJUER/tk61NcaAORUg3071JdmGxqTY=
Message-ID: <aec7e5c30810150103p7ed810ccyc815ad578d64feac@mail.gmail.com>
Date: Wed, 15 Oct 2008 17:03:07 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] soc-camera: fix compile breakage on SH
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Stefan Herbrechtsmeier" <hbmeier@hni.uni-paderborn.de>,
       "Mauro Carvalho Chehab" <mchehab@redhat.com>, lethal@linux-sh.org,
       linux-sh@vger.kernel.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, "Magnus Damm" <damm@igel.co.jp>
In-Reply-To: <Pine.LNX.4.64.0810150836100.3896@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081014183936.GB4710@cs181140183.pp.htv.fi>
	 <Pine.LNX.4.64.0810142335400.10458@axis700.grange>
	 <20081015033303.GC4710@cs181140183.pp.htv.fi>
	 <20081015052026.GC20183@cs181140183.pp.htv.fi>
	 <aec7e5c30810142328n1563163bw636b8baf1a47ad8b@mail.gmail.com>
	 <Pine.LNX.4.64.0810150836100.3896@axis700.grange>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Wed, Oct 15, 2008 at 3:41 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Magnus
>
> On Wed, 15 Oct 2008, Magnus Damm wrote:
>
>> Thanks for working on fixing the breakage. I'd prefer to wait a bit
>> since there are quite a few pinmux patches queued up that may break if
>> we merge a fix right now. I can fix it up later on.
>
> no, I would not leave the kernel in a non-compilable state even if just
> for one board. Please, test a new version of the patch below. And yes, You
> will have to rebase your patches, sorry. Another thing, could you also,
> please, add a license / copyright header to
> include/media/soc_camera_platform.h?

I'm not asking you to keep the board broken forever. It's just a
question of in which order the trees are getting merged. Again, I'd
rather see that this fix is put _on_top_ of the patches that are
already queued up in the SuperH tree. Merging it before doesn't help
anything in my opinion - especially since the change should go though
the SuperH tree anyway.

Feel free to add any header you like. =)

/ magnus
