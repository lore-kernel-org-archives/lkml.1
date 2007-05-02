Return-Path: <linux-kernel-owner+w=401wt.eu-S2993062AbXEBMFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993062AbXEBMFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993061AbXEBMFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:05:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993054AbXEBMFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:05:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <m1fy6fxwx5.fsf@ebiederm.dsl.xmission.com> 
References: <m1fy6fxwx5.fsf@ebiederm.dsl.xmission.com>  <m1y7k8x910.fsf@ebiederm.dsl.xmission.com> <alpine.DEB.0.98.0705011054060.12931@sigma.j-a-k-j.com> <20061127165138.GA2991@lst.de> <20070430040213.BF9901801A4@magilla.sf.frob.com> <20070430091121.GC31397@infradead.org> <20070430100917.439ebfc8.akpm@linux-foundation.org> <a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com> <Pine.LNX.4.64.0705011058330.27246@anakin> <1178028973.2875.78.camel@pmac.infradead.org> <9185.1178035627@redhat.com> <24844.1178098371@redhat.com> 
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: condingstyle, was Re: utrace comments 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 02 May 2007 13:05:34 +0100
Message-ID: <31688.1178107534@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> wrote:

> > But the condition doesn't line up with the code:
> 
> Exactly.  The condition not lining up with the following code helps
> code helps separate the two.

Sorry about that: I realised you were agreeing with me about 5s after I sent
the message.

> However there is the practical way to solve this if you have
> a sufficiently large conditional, or the conditional appears
> several times.

That doesn't necessarily work - for instance if the condition has side effects
on local variables (eg: postinc).  OTOH, large complex conditions with side
effects have to be abused with care and preferably avoided.  goto is your
friend:-)

David
