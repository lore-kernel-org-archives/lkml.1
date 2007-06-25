Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbXFYVSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbXFYVSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbXFYVSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:18:02 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:18454 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbXFYVSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:18:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IDO6Z6iiCJ9KPhtFMpHgMyOcZKv8fV0cIY8cDK7ecr/Ylatx26NAiuGql+8ja8I9JGd2V9vBcrqGMS+RPOajKrpVWhCxd7iiye96R9PcFUWfAHxw870i3++n4L5+byxcYs4LJOKatItkJdFGkYc+PWEErjlfPW2FcQVFMXh5ubo=
Message-ID: <9a8748490706251417v10b3f24bwdf7ebd44093eaddf@mail.gmail.com>
Date: Mon, 25 Jun 2007 23:17:59 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "John Stultz" <johnstul@us.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200706252309.47467.zippel@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070625200601.GA18980@elte.hu>
	 <200706252309.47467.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> Hi,
>
> On Monday 25 June 2007, Ingo Molnar wrote:
>
> > the patch improves the sysbench OLTP macrobenchmark significantly:
>
> Has that any real practical relevance?
>
It seems to me that Ingo's patch offers slightly improved performance
for any program using the time() system call, with no real drawbacks,
so why wouldn't we want to use it?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
