Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbXFKUpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbXFKUpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbXFKUpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:45:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:31406 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbXFKUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:45:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=n4qkaLhEjU51aHc+OMla2K0GTpNQ8mDoUQg5c4vFz6zP/KmbXa+Bze9/3ivUhWbndUy9hVoRw/dY9+vDjvWX9LEMSgZf4Vc+z2y914gUNdJX0YdE9EhANgrd3y74WSfrS3NxaSTb/euDamP4yOdhrILT7RbzwBqdt/YS0fDwQUY=
Date: Tue, 12 Jun 2007 00:52:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christoph Hellwig <hch@infradead.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/2] PTRACE_PEEKDATA consolidation
Message-ID: <20070611205225.GE5715@martell.zuzino.mipt.ru>
References: <20070611204006.GC5715@martell.zuzino.mipt.ru> <20070611203517.GA22252@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611203517.GA22252@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 09:35:17PM +0100, Christoph Hellwig wrote:
> On Tue, Jun 12, 2007 at 12:40:06AM +0400, Alexey Dobriyan wrote:
> > Identical implementations of PTRACE_PEEKDATA go into
> > simple_ptrace_peekdata() function.
> >
> > compile-tested on ~half of archs, playing with gdb on x86_64.
>
> Looks good.  Why don't you call it generic_ptrace_peekdata instead of
> simple_ptrace_peekdata, though?

Because they're simple :) I was probably spoiled by libfs.c .

