Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbXGOHU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbXGOHU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 03:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbXGOHUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 03:20:21 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:57922 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbXGOHUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 03:20:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LuLNpKkNsYhYDZZ7i3EkroR5ycHP8OxgEbebP+xjXk709aAV5pG476VqR+E4StNduuQ4Ao2Mj18yB4i5ipjEDLJ3v/ByCUqoot6PEhISy3FVAeXJ95JK1RIx9QebFVeNJpxD7iAdZrU6sZmvFe9b+aj12mk9eqy9bi+YWO/jylg=
Message-ID: <8bd0f97a0707150020s33e698d4q702018e08aeb59bc@mail.gmail.com>
Date: Sun, 15 Jul 2007 02:20:19 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Olaf Hering" <olaf@aepfle.de>
Subject: Re: [PATCH] remove PAGE_SIZE from headers_install
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070715062708.GA11909@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070714205709.GA9478@aepfle.de>
	 <8bd0f97a0707141404k16e53945s92b3cd4264ecf0aa@mail.gmail.com>
	 <20070715062708.GA11909@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/15/07, Olaf Hering <olaf@aepfle.de> wrote:
> On Sat, Jul 14, Mike Frysinger wrote:
> > imo, asm/page.h should just go away for userspace.  the attached patch
> > is what i've been using in Gentoo ... but somethings (like an arch or
> > two in glibc) still assume asm/page.h is OK.  in general though,
> > considering asm/page.h has become so unreliable lately (a large number
> > of arches ifdef the whole thing out), most packages out there have
> > updated already to use the userspace interface from unistd.h.
>
> You need that signed-off thing, and dont forget to send it to
> stable@kernel.org

i honestly didnt think people would consider it for inclusion as it
was since i ripped out a lot more headers than just asm/page.h ;)

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
