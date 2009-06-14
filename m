Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbZFNGSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbZFNGSB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 02:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbZFNGRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 02:17:53 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:37185 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZFNGRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 02:17:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=GjVNvePPgCtkipDC4J+T2A0Y1exgl8iku7SldQwCgwomFdxDYuoKg8Q8KFoXx9oNK6
         8oEmrOqs+4KaKCg0GRmwRx0BdyIZp3LzqOunBLVVjehLsE0SfG3Aof2ofblwqagW6GJo
         LcfGvb1KZqrOBX7eoUAr5Eqh3W16sfOuMMk+8=
Subject: Re: [PATCH] kmemtrace:fix undeclared 'PAGE_SIZE' via asm/page.h
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Linux-MIPS <linux-mips@linux-mips.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <84144f020906132259v2637b436vbc42b49c2adf06ff@mail.gmail.com>
References: <1244958863-28899-1-git-send-email-wuzhangjin@gmail.com>
	 <84144f020906132259v2637b436vbc42b49c2adf06ff@mail.gmail.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Sun, 14 Jun 2009 14:17:46 +0800
Message-Id: <1244960266.4968.162.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-14 at 08:59 +0300, Pekka Enberg wrote:
> On Sun, Jun 14, 2009 at 8:54 AM, Wu Zhangjin<wuzhangjin@gmail.com> wrote:
> > From: Wu Zhangjin <wuzj@lemote.com>
> >
> > when compiling linux-mips with kmemtrace enabled, this error will be
> > there:
> >
> > include/linux/trace_seq.h:12: error: 'PAGE_SIZE' undeclared here (not in
> >                                a function)
> >
> > I checked the source code and found trace_seq.h used PAGE_SIZE but not
> > include the relative header file, so, fix it via adding the header file
> > <asm/page.h>
> >
> > this error will not be triggered in linux-x86 for there is a
> > <asm/page.h> header file included in a certain header file. but which
> > not means <asm/page.h> is not needed in trace_seq.h
> >
> > Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
> 
> This looks like a generic tracing issue, not a kmemtrace problem so
> the subject line needs fixing. But the change looks good to me:
> 
so, what about this subject?
	
  ftrace: fix undeclared 'PAGE_SIZE' in include/linux/trace_seq.h 

> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

will add it later.

thanks!
Wu Zhangjin

