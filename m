Return-Path: <linux-kernel-owner+w=401wt.eu-S938004AbXG0Vbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938004AbXG0Vbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 17:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935269AbXG0Vbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 17:31:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:64411 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935176AbXG0Vbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 17:31:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FjDuY/AWU7FUu+u1Wtv0MLy0Fi6HUqIIgsqrxWH+cxR/38YLm2RwqNQ83I19FnhT3UUhrbtFpqimkMdKWHL+zVYDE1ljNIf2xoqlm1XZFeLQV8hKvZsoy/ZocmqqZdgrkNvQXy7GXxP4BVoQjMrzO87PQ8Wi2NXuzt/hnTjUYvg=
Subject: Re: Problems with framebuffer in 2.6.22-git17
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Adrian McMenamin <adrianmcmenamin@gmail.com>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       lethal@users.sourceforge.net
In-Reply-To: <92a12cdb0707271318t141ee32bs69cb9dab22eabba2@mail.gmail.com>
References: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
	 <1185146563.6370.8.camel@daplas>
	 <8b67d60707241445l2764d9f1odb72848342135048@mail.gmail.com>
	 <1185406433.5046.23.camel@daplas>
	 <92a12cdb0707271247s727993b8i33999a9652b2ca20@mail.gmail.com>
	 <92a12cdb0707271318t141ee32bs69cb9dab22eabba2@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 28 Jul 2007 05:31:30 +0800
Message-Id: <1185571890.26603.7.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 21:18 +0100, Adrian McMenamin wrote:
> On 27/07/07, Adrian McMenamin <adrianmcmenamin@gmail.com> wrote:
> 
> > With the patch reverted and 24bpp, it oopses before freezing (with two
> > odd looking boot logos on the screen):
> >
> Tested this further and it fails on:
> 
> rev = fb_readl(par->mmio_base + 0x04);

Doubtful if this line is the point of failure, this line is executed
only once, on initialization.

> 
> Will try to see what's up - but if anyone knows what is likely to be
> wrong here please shout out!

I'm still thinking there's something wrong on how the resources are
allocated causing a pseudo_palette overrun. 

I'll post a clean-up patch later.

Tony

