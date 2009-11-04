Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZKDSof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZKDSof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbZKDSof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:44:35 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:34250 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491AbZKDSoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:44:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=k+4YYlkLiF00JgC+EOOl9NWqHJifDASCNfIv2S9tDePquqv88QYQt1fgKOVcPhGRuB
         ltbJjNd++E0iw81VR64nPRPUUnQAOofYvjEUJL1vAI31CZQT16DMQJjy4wKoY00KZgWl
         6Hq7Gg+Xv+felKEBgquBazzwp+gMjyUH6FFhU=
MIME-Version: 1.0
In-Reply-To: <20091104173258.28463.94619.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173258.28463.94619.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 19:44:39 +0100
Message-ID: <14add3d10911041044m53d97880j3c57648b4652c5fb@mail.gmail.com>
Subject: Re: [PATCH 08/41] rt2800usb: use rt2x00usb_register_multiwrite() to 
	set key entries
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 6:32 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: use rt2x00usb_register_multiwrite() to set key entries
>
> Since struct hw_key_entry is 32-bytes large and is smaller than
> CSR cache size (which is 64-bytes large) we can use the standard
> rt2x00usb_register_multiwrite() helper to set key entries.
>
> This cleanup is a part of preparations for later code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
