Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbXJGTju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbXJGTju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 15:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbXJGTjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 15:39:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:34841 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbXJGTjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 15:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Le/IH4MT9+Xjy7p8I8ZW0MnqYGerh9SrRCAqdOQgbYSUNQ+remx55KDo7jU56bKwpJJGZ+rm2OzAPloXnfwFonhM19flZ4MJY8CPUofDKdjIjNkfiWDlGtsQpJMdTFKOxriXNkJHvuYbZUuJ+0bptznml9UhRPQKs6LwO0nDLl0=
Date: Sun, 7 Oct 2007 21:39:32 +0200
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Oops] on 2.6.23-rc9 sysRq Show Tasks (t)
Message-ID: <20071007193932.GA3300@Ahmed>
References: <20071006201405.GA2530@Ahmed> <20071006211238.GB7924@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006211238.GB7924@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2007 at 01:12:38AM +0400, Alexey Dobriyan wrote:
> On Sat, Oct 06, 2007 at 10:14:06PM +0200, Ahmed S. Darwish wrote:
> > Pressing sysRq+T always produce an Oops for every running system task (94 
> > Oopses, that's a record ;)).
> 
> uh-oh. For every sleeping task, I think.
> 
> > The bug is 100% reproducable. Should I begin bisecting/investigating the 
> > issue or it's a known problem ?
> 
> Start with some old kernel, like mmm.. 2.6.0. The fact that same behaviour
> was present there may make you think about faulty assumptions you've
> made.
> 

Yeah I understood my mistake (not an Oops, a normal behaviour). 
Thanks for your advice :).

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
