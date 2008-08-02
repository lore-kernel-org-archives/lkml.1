Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbYHBO2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbYHBO2v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 10:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYHBO2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 10:28:42 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:53954 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYHBO2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 10:28:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=np2si7mqZ7o9ayhUAMxw1rXJbsGeP/ncboslfA6vG+RjMvIO5wKQnRXn05PNJy8xXS
         1ym24Uyj6NzfrdURtvI+ju/afjX3KGKSlsdh11hBVnV6Rn9bkozSaqDELc0AaLJrhk1u
         RZL3xXkGGuZSJNw+3a7WwUH51FZw67Xs84r0Q=
Date: Sat, 2 Aug 2008 18:28:38 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Paul Jackson <pj@sgi.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 2/2] cpuset: use seq_cpumask(), seq_nodemask()
Message-ID: <20080802142838.GA338@martell.zuzino.mipt.ru>
References: <20080802113131.GB3536@martell.zuzino.mipt.ru> <20080802090542.51052006.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080802090542.51052006.pj@sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 09:05:42AM -0500, Paul Jackson wrote:
> Alexey wrote:
> > Folks might want to boot with NR_CPUS=4096 and see what happens,
> > m->count games don't look promising. :-)
> 
> That comment is rather heavily dependent on the context of both:
>  1) the previous patch comment, and
>  2) booting and seeing.
> 
> Could you rewrite it, so that it doesn't depend on such context,
> and can be read and understood, by itself?

That's just a reminder to cpuset people whether /proc/*/status broken or
not. Can be safely deleted. :-)

