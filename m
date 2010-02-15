Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0BOUjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:39:06 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:34930 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab0BOUjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:39:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FIHZebkxceKUchRBLgiUsfuXKto7pqSrn8FU/DJgG9i35SCRPchUqxXDi6NUYtZBHP
         na1xaWLIVUdy706pn/+l0lBEmtDdr56XdKHAVjgKyKpPbTOakHvY8sZX37Q21Aj1QtmN
         sHfGTlvdm6zouIAf1oti5/LGk/+5cMtic9Xgc=
MIME-Version: 1.0
In-Reply-To: <20100215201201.GA3332@joi.lan>
References: <alpine.DEB.2.00.1002110417200.516@skynet.skynet.ie>
	 <201002151053.48681.borntraeger@de.ibm.com>
	 <20100215201201.GA3332@joi.lan>
Date: Mon, 15 Feb 2010 21:39:00 +0100
Message-ID: <6d4bc9fc1002151239x2b994ea9l7f868d9bb8f789e9@mail.gmail.com>
Subject: Re: [git pull] drm
From: Maarten Maathuis <madman2003@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       nouveau@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The channel/context switch lock related patches (to the best of
knowledge) haven't even gone outside the nouveau tree, so the initial
damage isn't even there. At least not for the first path. As for the
2nd patch, that one was squished into the original patch for this pull
iirc.

Maarten.

On Mon, Feb 15, 2010 at 9:12 PM, Marcin Slusarz
<marcin.slusarz@gmail.com> wrote:
> On Mon, Feb 15, 2010 at 10:53:48AM +0100, Christian Borntraeger wrote:
>> Am Donnerstag 11 Februar 2010 05:20:07 schrieb Dave Airlie:
>>
>> Dave,
>>
>> I just updated from to rc8 and got the a scheduling while atomic warning in
>> nouveau. (see below).
>
> Linus' tree is missing two fixes:
>
> drm/nouveau: don't hold spin lock while calling kzalloc with GFP_KERNEL
> drm/nouveau: spin_lock_init after memset'ing the bios struct
>
> The first one fixes your bug.
>
> http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=ed64797d153ecf0da79b8b849642d7a109fd97fd
> http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=9da76700072a00c39e21553df0998c7b3b620d88
>
> If they won't go into 2.6.33, they are perfect candidates for -stable.
>
> Marcin
>
