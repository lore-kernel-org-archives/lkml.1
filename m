Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbXFLWVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbXFLWVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 18:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbXFLWVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 18:21:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:57947 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbXFLWVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 18:21:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JmWyof/g+0pwTJuFLahT0LdwtKzXBH9UV0/gtd9sUikc7oBhkYWJs95aA2NxR3sFWD/752bN83CWgD4JvzIZFjuUttALFOexR/N3aINdATRGNH5Y7oUXccF0yhyB4aycmrgeTHYbYMiGuSCOrJrGgdQ2VejKlK1VctpmLG7hvzQ=
Message-ID: <9a8748490706121521q1192b9dbp6b2adff087fc01d@mail.gmail.com>
Date: Wed, 13 Jun 2007 00:21:43 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: dedekind@infradead.org
Subject: Re: [PATCH] fix memory leak in UBI scanning unit
Cc: linux-kernel@vger.kernel.org, dedekind@linutronix.de
In-Reply-To: <1178784573.3734.5.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705100026.12639.jesper.juhl@gmail.com>
	 <1178784573.3734.5.camel@sauron>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/07, Artem Bityutskiy <dedekind@infradead.org> wrote:
> On Thu, 2007-05-10 at 00:26 +0200, Jesper Juhl wrote:
> > In drivers/mtd/ubi/scan.c::paranoid_check_si() there's a memory leak.
> > If the call
> >       err = ubi_io_is_bad(ubi, pnum);
> > returns <0, then we'll return with out freeing (and thus leak) buf.
> > This patch eliminates the memory leak by freeing buf before returning.
> >
> > Problem spotted by the Coverity checker.
>
> It was already reported and fixed in our git tree. But thanks anyway.
>
Any idea when you'll be merging with Linus?
I just checked mainline git and the bug is still there :-(

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
