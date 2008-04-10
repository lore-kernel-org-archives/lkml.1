Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbYDJWJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbYDJWJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756992AbYDJWJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:09:38 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:57971 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691AbYDJWJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:09:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uPlmjoSsHYjg6yZFyVaNy/ysNYsXAQsD3t/Ph2g40z+S9x4OyhWkEUvQkTydjqVUResXhbLn3lJ7TW1hUMUjnnxaZyHxbAALTdKjeEmR5gj4YjiLxG1aWXV/VkmtECFwI8MTWBfojF802HCzRROQLaIGFy6m69kc0c3bD08o1Zw=
Message-ID: <9a8748490804101509l5d043ff8w565dc44dfeaf0072@mail.gmail.com>
Date: Fri, 11 Apr 2008 00:09:11 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Tilman Schmidt" <tilman@imap.cc>
Subject: Re: 2.6.25-rc8: FTP transfer errors
Cc: "David Miller" <davem@davemloft.net>, lkml@rtr.ca, yoshfuji@linux-ipv6.org,
       jeff@garzik.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org
In-Reply-To: <47FE3020.1070502@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47FD138B.2060801@rtr.ca>
	 <20080409.152933.132174258.davem@davemloft.net>
	 <47FD590C.5020003@rtr.ca>
	 <20080409.182228.193699767.davem@davemloft.net>
	 <47FE3020.1070502@imap.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2008, Tilman Schmidt <tilman@imap.cc> wrote:
<...>
>
>  Bisecting is a time-consuming process. If unwillingness to bisect
>  is unacceptable in a bug reporter then people who don't have the
>  time to bisect must stop reporting the problems they encounter.
>

I hope that was a joke and that I just don't get it.

Are you really saying that if somebody find a bug they shouldn't
bother reporting it unless they are willing to spend hours and hours
of work to get it fixed?

The way I see it, the burden of debugging and fixing bugs is mainly on
the developers of the code that breaks. You can't blame users for
using the code, triggering bugs and then reporting the breakage.
Users who report bugs are doing us all a great service regardless of
their ability or willingness to do more work than just the initial
report.

If bugs don't get reported they'll never get fixed. Even a bad bug
report with no follow up at all still allows us to use it to gauge how
often a specific bug is being hit and thus how important it may be to
fix it.

You can't expect users to know how to debug a problem or even bisect
it. A user may not even be able to compile a custom kernel but she may
still hit a bug and do us the favour of reporting it. It should be the
job of the developer of the code to investigate the bug following a
users report.

Sure it's great when users can bisect, provide test cases, debug the
problem completely themselves or even provide a patch, but you can't
expect that. And in my oppinion you certainly can't just hide behind
"the user doesn't want to bisect so I won't fix this" and use that as
an excuse for the code being buggy. I hope most people take bug
reports more seriously than that.

When people discover bugs in my own code I thank them and feel a bit
ashamed that I didn't do my work properly and it then becomes very
important to me to make sure I squash the bug.  The more the user can
help the better, but if they cannot help beyond telling me what broke
and how, then that's fine too. I still want to nail the bug and I'll
just have to do more work myself, but it becomes a matter of personal
and professional pride to hunt down the bug.

We need to be grateful to users who report bugs - most of them don't bother.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
