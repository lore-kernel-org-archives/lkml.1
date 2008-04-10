Return-Path: <linux-kernel-owner+w=401wt.eu-S1759219AbYDJXk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbYDJXk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 19:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757377AbYDJXjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 19:39:49 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:60206 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbYDJXjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 19:39:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tNREWnm836NftprTpCIqEVORw+jAc2I+KbjSt6EyzS+HYrgRgmdhYQDWCGt4iF8S8NE9n2VCpshGqKPVWMi+9CaDipLxPrEi1XHMqrRWfhSf6WY+j1MlroxTfvSaT8frNM/XWlfU7khZCG2yYunWEskVP3Z4NOk6ymAPBNIZlXA=
Message-ID: <9a8748490804101639s7adf468dp6bf4241da5845eea@mail.gmail.com>
Date: Fri, 11 Apr 2008 01:39:22 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: vincent-perrier <vincent-perrier@club-internet.fr>
Subject: Re: 2.6.25-rc8: FTP transfer errors
Cc: "David Miller" <davem@davemloft.net>, tilman@imap.cc, lkml@rtr.ca,
       yoshfuji@linux-ipv6.org, jeff@garzik.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
In-Reply-To: <1207869029.19683.13.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080409.182228.193699767.davem@davemloft.net>
	 <47FE3020.1070502@imap.cc>
	 <9a8748490804101509l5d043ff8w565dc44dfeaf0072@mail.gmail.com>
	 <20080410.154651.101700010.davem@davemloft.net>
	 <1207869029.19683.13.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2008, vincent-perrier <vincent-perrier@club-internet.fr> wrote:
> I am an end user, I do not know precisely what bisecting means, but I
>  have spent some time on bug 8895, I suppose I have totally bisseced it,

"bisect" refers to the "git bisect" command of the git tool.

For information on git, look here: http://git.or.cz/

For information on "git bisect" look here:
http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html
and here: http://www.kernel.org/pub/software/scm/git/docs/user-manual.html#using-bisect

Basically what bisect does is this; you tell it about your
last-known-good kernel version and your first-known-bad kernel
version. Then git finds all the changesets between those two version,
cuts the set in half and produces the kernel source matching the
middle point. You can then build and test that kernel and then you
tell git if it was good or bad - it'll then use that good/bad info to
cut the set of patches in half again etc etc until you eventually end
up with the exact changeset that caused your problem.  It's very
powerful and can often narrow a problem down to a single commit, but
it does require that your problem is completely reproducible so that
you can reliably test it on each kernel 'git bisect' produces for you.

[please don't top-post : http://www.catb.org/~esr/jargon/html/T/top-post.html ]

<...snip...>

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
