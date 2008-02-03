Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbYBCPnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbYBCPnf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 10:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbYBCPnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 10:43:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:44871 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbYBCPnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 10:43:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mIstDQFpcEvxwMkdLLN+UFAMGOC0yqiUUv5ZEz243luza+II1U4PjYuhxUygUJOe8wadPVYhftWNCaX3dr9WBHmZWMSwZRbv1QSdTQkntXGpLXF6XNexOvFuFheYGqh2ByDUsyQ5ctfu4S9Z2IW2/u8MaTZmFe8bGBx/bynHmzk=
Message-ID: <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
Date: Sun, 3 Feb 2008 17:43:24 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "David Newall" <davidn@davidnewall.com>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Cc: "Greg KH" <greg@kroah.com>, "Christer Weinigel" <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <47A5D9CD.5070001@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080125180232.GA4613@kroah.com>
	 <20080202123710.42df1aa0@weinigel.se>
	 <20080202191930.GA19826@kroah.com> <47A5D9CD.5070001@davidnewall.com>
X-Google-Sender-Auth: 8b3a4241d3184a0c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Feb 3, 2008 5:12 PM, David Newall <davidn@davidnewall.com> wrote:
> By the way, I'm almost certain that the COPYING file is the first, last
> and only document specifying licence conditions, and nothing in that
> prevents a proprietary driver from including a patch that, for example,
> globally replaces ALL GPL-only symbols by the less restrictive ones.

So I am going to assume you're not trolling here (although some of
your snarky remarks make that bit hard).

A vendor is, of course, allowed to distribute a patch (under the GPLv2
proper) that removes the license checks no doubt‚ but it doesn't
change the fact whether the actual driver they're distributing (under
a proprietary license) is derived work or not (one way or another).
And, _if_ you're distributing a derived work that is not under the
GPLv2, you're breaking the law. I think we can agree on this?

As there is some controversy over the definition of derived work
(think Linus' comments on porting a driver or a filesystem from
another operating system here), we use the EXPORT_SYMBOL_GPL
annotations as a big warning sign that what you're doing is likely to
be considered as a derived work. If the USB developers want to
annotate their code with EXPORT_SYMBOL_GPL, why the hell do you want
to argue about it? They know the code better than you and as copyright
holders they can actually sue those parties distributing proprietary
code they think is derived work.

Bringing up Linux world domination or Microsoft market share in these
kind of discussion is totally pointless. The license is what it is
(GPLv2) and it seems unlikely to change at this point. If you want to
develop for Linux, you're most certainly better off always
distributing your code under the GPLv2; otherwise you really really
want to consult an IP lawyer to be sure. But what I don't understand
is why people insist using the Linux kernel for something it clearly
can never really properly support (proprietary code)?
