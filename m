Return-Path: <linux-kernel-owner+w=401wt.eu-S1751464AbXBDAFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbXBDAFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 19:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbXBDAFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 19:05:40 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:1634 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbXBDAFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 19:05:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=cDYSVJLftzhtfcltAu7LlkTl8s7lqzxhjNfjgWpE9Pv4epI2P2lLcVsY1mnYVX8EFbJkWUHL+BUstHAveHlymKfhlq/zMOlI0s+5j/hA1HEo5p0FxHycY3aIgVu9STxryg3f8t+gG8Fd/B9EyMcht+aK9IhLjhzYglymlylhgEk=
Date: Sun, 4 Feb 2007 02:05:32 +0200
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: A CodingStyle suggestion
Message-ID: <20070204000532.GA20721@Ahmed>
References: <20070203215848.GA10440@Ahmed> <45C51310.6070304@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C51310.6070304@student.ltu.se>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 11:56:16PM +0100, Richard Knutsson wrote:
> Ahmed S. Darwish wrote:
> >Hi all,
> >
> >In CodingStyle Chapter 16 "Function return value and names", why not
> >adding a comment about the favorable community way of checking the return
> >value. ie:
> >
> >ret = do_method();
> >if (ret) {
> >   /* deal with error */
> >}
> >
> >and not other ways like:
> >
> >if (do_method()) or 
> So:
> 
> if (is_true()) {
> 	/* do something */
> }
> 
> is alright then? If so, I agree, but please make it real clear in the 
> document ;)

Good catch :). A small grep of `access_ok' reveals that it's always used in the 
form of:
if (!access_ok()) { .. }

I can conclude that verbal/imperative methods like `kmalloc, add_work' be 
checked as:
ret = do_work();
if (ret) { ... }
and predicate methods like `acess_ok, pci_dev_present' be checked like:
if (!access_ok) { ... }
if (pci_dev_present) { ...}

Any comments ?

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
