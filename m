Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbXFUNwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbXFUNwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbXFUNvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:51:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:28376 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232AbXFUNvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=UnC+dYT3R3aaqFmy1fYzsD5LHNyA7fkz2q69A+aakp7/nLTLEVg4QOUQklI6B0YTdFbnVasYAkUgxNIkGFmeDGmwiYSW8UHsfMljQxeqKZ1f9fiFp2pKRQPHiAo796lfgMzSfFS2jYhNSgtffZ7tJiQ0ddiog8i9niReXs4479o=
Date: Thu, 21 Jun 2007 17:49:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bracing the loop in kernel/softirq.c
Message-ID: <20070621134933.GA6589@cvg>
References: <20070620175737.GA6523@cvg> <9a8748490706201401m36b1e917g5a600951d48e4cf8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490706201401m36b1e917g5a600951d48e4cf8@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jesper Juhl - Wed, Jun 20, 2007 at 11:01:44PM +0200]
| From: Jesper Juhl <jesper.juhl@gmail.com>
| To: Cyrill Gorcunov <gorcunov@gmail.com>
| Cc: LKML <linux-kernel@vger.kernel.org>
| Subject: Re: [PATCH] bracing the loop in kernel/softirq.c
| Date: Wed, 20 Jun 2007 23:01:44 +0200
| 
> On 20/06/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> This trivial patch adds braces over a one-line
>> loop. That makes code...well... little bit
>> convenient for (possible) further modifications.
>>
> That's generally not done.
>
> It's even in Documentation/CodingStyle :
>
> "
> Do not unnecessarily use braces where a single statement will do.
>
> if (condition)
>        action();
> "
>
> -- 
> Jesper Juhl <jesper.juhl@gmail.com>
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please      http://www.expita.com/nomime.html
>

Hi Jasper,

look, the CodingStyle is absolutely right BUT:

	- dropping the braces are good solution for 'if' statement indeed
	- dropping the braces are _not_ good for 'do' - 'while' loop 'case
	  it fails on further loop modifications. Moreover adding these braces
	  we don't change amount of lines in code! So why souldn't we? I don't
	  see any reason not to do.

		Cyrill

