Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbXFNWwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbXFNWwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbXFNWwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:52:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:65027 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbXFNWwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VoUiCjAkTkd/u4oug/inIw0OPGWJl8/GzJHqMuMSukSass/7Y4P0lJ7FXeOM6EaKNhaYykN6xYJGcRx3NK3upnV6HHBK5tGe1iymYBVUrSwVyxj/hDmhT3HE1CDB3oWOzUFGn9ndIJYlncmbz5IICBL0/+UkEe7oT4UVl/Te62U=
Message-ID: <9a8748490706141552l6d112c16tc306784664c6504d@mail.gmail.com>
Date: Fri, 15 Jun 2007 00:52:20 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: davide <davidenitti@gmail.com>
Subject: Re: Random X lockup
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4671AF64.9050201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4671AF64.9050201@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/07, davide <davidenitti@gmail.com> wrote:
> I have a problem with X, I have random lockup of X, when happen i can't
> use mouse or keyboard.
> Using a SSH remote session I can see that X taking 99.9% cpu.
> I have this problem with all version of kernel, linux distributions,
[snip]

Have you tried building and running a kernel with some (or all) of the
debugging options enabled (you find those in the "kernel hacking"
section of the kernel config)?
Hopefully one or more of those debug options will provide some info in
dmesg to help find the source of the problem.


> -- GFX cards: Radeon 9200, Radeon 9700, NVidia GeForce2 GTS/Pro, GeForce
> Ultra 5700, Geforce FX 5200

Are you using any proprietary, closed source, X drivers for those
graphics cards? If yes, then the first thing to try would be to use
one of the open source drivers - for example, use the 'nv' driver for
the nVidia cards instead of the 'nvidia' driver. If your kernel is
tainted by a close source driver nobody here will be able to help you
debug the issue.
If you can't reproduce the issue with an open source driver, then you
should contact your graphics card vendor for help as they are the only
people who will be able to help you with problems involving their
closed driver.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
