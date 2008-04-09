Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbYDITAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbYDITAD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:00:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYDIS7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:59:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbYDIS7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:59:53 -0400
Date: Wed, 9 Apr 2008 15:58:00 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       abraham.manu@gmail.com
Subject: Re: [v4l-dvb-maintainer] [PATCH] media: replace remaining __FUNCT
 ION__ occurences
Message-ID: <20080409155800.3c321b76@areia>
In-Reply-To: <1207765825.16220.16.camel@brick>
References: <1204613661.22933.110.camel@brick>
	<47F536FF.8060105@linuxtv.org>
	<37219a840804040809q470a64fdmed95e21bd51c23b0@mail.gmail.com>
	<37219a840804091000y34ba76e2x4937600ae7bda3a5@mail.gmail.com>
	<1207765825.16220.16.camel@brick>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.1; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Apr 2008 11:30:25 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> For such a large set in v4l, it's a drastic increase in work to do so
> in this case as it is a simple sed s/__FUNCTION__/__func__/

I think the "sed" approach is the better, on this case. It avoids mistakes that
might be caused by manual changes of that amount of line changes.

> > I understand if you don't want to alter code that you may not be
> > directly involved in, but I am sure you will have no trouble at least
> > fixing the "comma after space" and "line over 80 characters" cases.
> > 
> > Please generate the additional cleanups against the mercurial tree
> > that I merged your previous series to:
> > 
> > http://linuxtv.org/hg/~mkrufky/function-func
> 
> Do you have a git mirror somewhere?

The V4L/DVB -git tree is at:
	http://www.kernel.org/git/?p=linux/kernel/git/mchehab/v4l-dvb.git

Also, linux-next is updated with the same patches applied on the above tree.

However, some manual adjustments may still be needed, since we have backward
compatibility code on Mercurial (to allow users to test V4L/DVB drivers on
older kernels).

At the -git, all those #if KERNEL_VERSION stuff that are inside Mercurial are
stripped.

Cheers,
Mauro
