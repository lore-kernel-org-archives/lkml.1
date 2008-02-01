Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbYBAKev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbYBAKev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbYBAKen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:34:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:37872 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbYBAKem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:34:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CYitdsNyqg4Gkz2ICVs+fgF+cJ5sbecUdielohnJ/zzzlI52Q4pMFyG0d3gtKrOyXZ/qRyA7ZhvLsa22I6urlruTWEm8GUD8jzr6HRb1P6YJpg/leo3IT8AgAtYkdIHJxVPUpFiobbarPPMmdnXlD38bLYb71idNUdrSCyKZZbQ=
Message-ID: <ee101c360802010234m4a7199e7g4cc9131484529b1c@mail.gmail.com>
Date: Fri, 1 Feb 2008 18:34:40 +0800
From: "Shuduo Sang" <sangshuduo@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: How does ext2 implement sparse files?
Cc: "Lars Noschinski" <lklml@ml.noschinski.de>, linux-kernel@vger.kernel.org
In-Reply-To: <p73myql50d2.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080131152823.GA29422@lars.home.noschinski.de>
	 <p73myql50d2.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 1, 2008 2:14 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Lars Noschinski <lklml@ml.noschinski.de> writes:
>
> > For an university project, we had to write a toy filesystem (ext2-like),
> > for which I would like to implement sparse file support. For this, I
> > digged through the ext2 source code; but I could not find the point,
> > where ext2 detects holes.
> >
> > As far as I can see from fs/buffer.c, an hole is a buffer_head which is
> > not mapped, but uptodate. But I cannot find a relevant source line,
> > where ext2 makes usage of this information.
>
> It does not explicitely detect holes; holey data is just never written
> so no space for it is allocated.
>

does anybody know how to make a hole in a large file which already has
real content from user space application?
In my project I need this function to delete a piece of content from
an exist large effectively.
thanks.

> -Andi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
