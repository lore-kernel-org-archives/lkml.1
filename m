Return-Path: <linux-kernel-owner+w=401wt.eu-S1161826AbXEDFf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161826AbXEDFf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 01:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161856AbXEDFf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 01:35:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:14001 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161826AbXEDFf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 01:35:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=GrAUIdc0P2sjf4de5CR0YKqitKhBFivr1ov3rSioC1SISQW2xnGlIfNYv2EMdRkrqskeVceDLSXUNOTUa7JW8dMDgVxZDZqbfZ+VGmhkQfGcHn/JRwEwe+cBq3rWssDIiStVHCJdhkkWPE+klRT8gaqgSP613sz5lHnBbKAe1kw=
Date: Fri, 4 May 2007 01:35:30 -0400
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2/6] add config option to vmalloc stacks (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070504053529.GA3245@nineveh.rivenstone.net>
Mail-Followup-To: William Lee Irwin III <wli@holomorphy.com>,
	Andi Kleen <andi@firstfloor.org>,
	Christoph Hellwig <hch@infradead.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
	Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174310.GE19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430174310.GE19966@holomorphy.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:43:10AM -0700, William Lee Irwin III wrote:

> +	  Allocates the stack physically discontiguously and from high
> +	  memory. Furthermore an unmapped guard page follows the stack.
> +	  This is not for end-users. It's intended to trigger fatal
> +	  system errors under various forms of stack abuse.

    Why is this not for end-users?  Will it not trigger anything
useful unless set up properly, or is a big performace hit -- and how,
or what?

    All the kernel debug options are underdocumented this way -- I'd
like to have as many of them on as I can without absolutely killing
performance, (or rather, *you* would) -- but I can never tell without
grovelling all over for the info, which... well, I haven't done it
yet, anyway.

    "End-user" is just insufficently defined for anyone compiling
their own kernel.  Could you add a bit more text here describing what
the effect of physically discontiguous high-memory stacks is?  An
additional frobnitz dereference on every badda-bing badda-bang, likely
to double the time it takes to dance the hokey pokey?

   *shrug*  Some of those debug options probably don't get set very
often on kernels that are run for more than to see if it boots.

--
Joseph Fannin
jfannin@gmail.com
