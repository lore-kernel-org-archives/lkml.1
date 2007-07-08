Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbXGHSxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbXGHSxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbXGHSxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:53:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:24615 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbXGHSxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:53:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gTsRPMOJuQ2ezSUFZ6aUILr7pV+PKyBkN9To5lRLlmrHykC2QoUJAWEnZ2WLycd19GLCzwa0hwZFuk+8iS6QIwYs8rlq80ByF1SZ8sxIAWjPvc3aR1uFs5elwDtc8DOYlmZa4VD+/z1LmgdAiWBn1m6dAb3E5kwlSVUvmbBek9g=
Message-ID: <9a8748490707081153k2f2e858bv2921f5cf763615f4@mail.gmail.com>
Date: Sun, 8 Jul 2007 20:53:03 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [PATCH] Some love to default profiler
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070708185115.GQ3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070704213420.GA5864@martell.zuzino.mipt.ru>
	 <9a8748490707041650s3b122007o46c8a34647b43af3@mail.gmail.com>
	 <20070708185115.GQ3492@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Thu, Jul 05, 2007 at 01:50:27AM +0200, Jesper Juhl wrote:
> > On 04/07/07, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >> 1) Drop __KERNEL__ out of profile.h. It contains only internal kernel
> >> stuff and
> >>    not in exported headers list
> >
> > Even if it's not in the list of exported headers, does it really hurt
> > to retain that extra safeguard?
> >...
>
> Safeguard for what?
>
Well, for userspace code that tries to include the file.  I know
nobody should, but somebody still might.   At least that was my
thought when I made that comment.

> And it has to be consistent, and current policy is to not have
> #ifdef __KERNEL__'s in all not to userspace exported headers.
>
Ok, in that case it should go away.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
