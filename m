Return-Path: <linux-kernel-owner+w=401wt.eu-S1030524AbXCSSir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524AbXCSSir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030567AbXCSSir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:38:47 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:54066 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030524AbXCSSiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OQELtxbcb1xbYsrebNbtMNdaW94gxMHQhtVZCeCDqS0mzpOYrY6vf3aZ0g8iQ0PdFOQGDwV1vVfotmNtDuAx5uxc4zC0ltTX2R/vkO1pL+fWMX1yzQmPN8iKrWXPoYFbXD3f8r4Qkt6R3k41cpugnLaKFO/X78LvXoYy+enLBF4=
Message-ID: <9a8748490703191138y7ff45fdbl538d2a941414817e@mail.gmail.com>
Date: Mon, 19 Mar 2007 19:38:45 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, fastboot@lists.osdl.org
Subject: Re: [Fastboot] [PATCH] [REVIEW] Fix irqpoll on IA64 (timer interrupt != 0)
In-Reply-To: <20070319183710.GA23499@strauss.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070319181336.GC12628@strauss.suse.de>
	 <9a8748490703191129h396211e9q59eeea9533d00c38@mail.gmail.com>
	 <20070319183710.GA23499@strauss.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/07, Bernhard Walle <bwalle@suse.de> wrote:
> * Jesper Juhl <jesper.juhl@gmail.com> [2007-03-19 19:29]:
> > >
> > > -void
> > > +int
> > >  register_percpu_irq (ia64_vector vec, struct irqaction *action)
> > >  {
> >
> > Each and every function example in Documentation/CodingStyle has the
> > return type on the same line as the function name, so why not get
> > these in-line while you are modifying them anyway?
>
> Because all other functions in that file are coded this way. I think
> it looks better if you don't change the style in a particular file.
> Am I wrong?
>
Consistency within the file certainly makes sense.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
