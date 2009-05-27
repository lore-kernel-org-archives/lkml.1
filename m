Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbZE0XQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbZE0XQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbZE0XQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:16:30 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:36301 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZE0XQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:16:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hk8A6/rURRK3KCxS2hViFy9qVKTPk+p5t0OqwqySDMetUqeCctW9/ONTYXUk+xIUI7
         w/Z8X2PSKU5Sfro3kXDpbAdMP3s3pVMOIwcdYCzu6h958DESFMGtn8Un+eZhlzEoyw2k
         q7G/9grtVNw8uaLcY4lsDr7f/i/1/NkcA/C9Q=
Date: Thu, 28 May 2009 01:16:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: Don't convert function's local variable name
	in macro
Message-ID: <20090527231627.GH5982@nowhere>
References: <4A1D41C2.2010903@cn.fujitsu.com> <20090527230505.GG5982@nowhere> <20090527231435.GC20509@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527231435.GC20509@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 01:14:35AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Wed, May 27, 2009 at 09:36:02PM +0800, Zhaolei wrote:
> > > "call" is a argument of macro, but it is also used as a local variable name of
> > > function in macro.
> > > We should keep this local variable name static although it haven't cause
> > > problem now.
> > > 
> > > [ Impact: cleanup, no functionality changed ]
> > 
> > 
> > I'm applying it.
> > 
> > Note, I'm also changing the impact line. This is more than a
> > cleanup, it's a real fix to prevent from possible CPP side effects.
> > 
> > So I'll put instead:
> > 
> > [ Impact: prevent from accidental CPP substitution ]
> 
> I suspect it should be something like:
> 
>   [ Impact: robustify macro ]


Ok, I take this one!

Thanks.

 
> or so.
> 
> 	Ingo

