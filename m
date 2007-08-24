Return-Path: <linux-kernel-owner+w=401wt.eu-S1765222AbXHXIp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765222AbXHXIp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 04:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763731AbXHXIpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 04:45:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:26223 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763708AbXHXIon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 04:44:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mM7DD3e+hSgGPw9XoEWMzCdBdjbevHgPrlnmec/nkjHQrq8BMTxN0TvS8laQmdif3xiI8NxtbAlUVrzZzxIjQxtymHjl5gEXqz9oiQrU9TM+JpTDJYsi2GhtU6ry34iH8zGIyJQR5I34G24IAZfYq4vCSpqMCrO6b161QRvYjE0=
Message-ID: <9a8748490708240144q598c11f5m6cd689b7fe2228a5@mail.gmail.com>
Date: Fri, 24 Aug 2007 10:44:42 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [PATCH 22/30] ivtv: kzalloc() returns void pointer, no need to cast
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kevin Thayer" <nufan_wfk@yahoo.com>, "Chris Kennedy" <c@groovy.org>,
       video4linux-list@redhat.com
In-Reply-To: <200708241032.14601.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	 <6e3f66d353155af12b075c2e919066908a2ce44c.1187912217.git.jesper.juhl@gmail.com>
	 <200708241032.14601.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/08/07, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Friday 24 August 2007 02:20:04 Jesper Juhl wrote:
> > Since kzalloc() returns a void pointer, we don't need to cast the
> > return value in drivers/media/video/ivtv/ivtv-queue.c
> >
> > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
>
> Jesper,
>
> Thanks for the patch. I've applied it to my latest tree and will ask
> Mauro to pull from it. The latest source is a bit different and has in
> fact a third cast which I've also removed.
>
Perfect, thanks.

> Thanks,
>
>         Hans

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
