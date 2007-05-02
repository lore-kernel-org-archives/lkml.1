Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbXEBJdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbXEBJdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbXEBJdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:33:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbXEBJdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:33:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <m1y7k8x910.fsf@ebiederm.dsl.xmission.com> 
References: <m1y7k8x910.fsf@ebiederm.dsl.xmission.com>  <alpine.DEB.0.98.0705011054060.12931@sigma.j-a-k-j.com> <20061127165138.GA2991@lst.de> <20070430040213.BF9901801A4@magilla.sf.frob.com> <20070430091121.GC31397@infradead.org> <20070430100917.439ebfc8.akpm@linux-foundation.org> <a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com> <Pine.LNX.4.64.0705011058330.27246@anakin> <1178028973.2875.78.camel@pmac.infradead.org> <9185.1178035627@redhat.com> 
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
Date: Wed, 02 May 2007 10:32:51 +0100
Message-ID: <24844.1178098371@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> wrote:

> Not lining up with the code following the if statement is also
> a plus.  Because it clearly delineates the conditions from the code.

But the condition doesn't line up with the code:

	if (veryverylengthycondition1 &&
	    smallcond2 &&
	    (conditionnumber3a ||
	     condition3b)) {
		this_is_some_code();
		this_is_some_more_code();
	}

Personally, for complicated conditions like this, I prefer:

	if (veryverylengthycondition1 &&
	    smallcond2 &&
	    (conditionnumber3a ||
	     condition3b)
	    ) {
		this_is_some_code();
		this_is_some_more_code();
	}

But that seems to offend Andrew for some reason (or was it Christoph? or
both?).

David
