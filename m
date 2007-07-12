Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbXGLUYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbXGLUYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbXGLUYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:24:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:65338 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624AbXGLUYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:24:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H3m5AbpibQktLQCL3BnGQ523OXeIUIMAEMT8I2uA10iDY06By7VYg3VQlaOQd4UDDyxBKQj64EFr6jGHeWWh41vQDM1DBlh/z4qtpQjwtk95PvuGUNa2i6wc5zct2M10nv54XEjLqhudAK0G6qh0DF66hfZee/GmK6rzTDY60b4=
Message-ID: <9a8748490707121324q3b3e6e65ye14ab8e7f089d999@mail.gmail.com>
Date: Thu, 12 Jul 2007 22:24:01 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707111916.35036.jesper.juhl@gmail.com>
	 <2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> On 7/11/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> > I'm wondering if it's time to make 4K stacks the default and to start
> > considering removing the 8K stack option alltogether soon?
>
> Why? Leaving the option for 8k stacks isn't killing any kittens, AFAICS.
>
Well, as long as 8K stacks are an option we'll never get all the code
that doesn't work properly with 4K stacks fixed. We *might* get all
the in-tree code fixed eventually, but there's still going to be lots
of out-of-tree code that will keep depending on 8K stacks. And as long
as 4K stacks are not reliable, distributions are stick with 8K for
their kernels, people who build their own kernel are probably also
going to stick to 8K most of the time, since that's the default.  This
makes the 4K stack option fairly pointless for most users.

If we consider 4K stacks broken, not used much, then we should just
get rid of that option. That would remove a config choice (of which we
have IMHO way too many already) and it would remove code that we then
no longer need to maintain.

If, on the other hand, we consider 4K stacks to be the superior
solution, then we should work to get all code fixed to be able to
handle it so that it's actually something distros will start to enable
so that we can eventually get rid of the 8K stack option alltogether.
Making 4K stacks default and no longer a debug option is just the
first step in that direction.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
