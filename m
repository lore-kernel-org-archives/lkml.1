Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbYLVWZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbYLVWZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbYLVWZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:25:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:1190 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbYLVWZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:25:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jbnwXFuaRUdK98xPu4DwYcHWylltrK5ZzYvIVanIq96nKo0fWMmrZ5JE8RANZye3wX
         aIJc1997jY6V4cKnTaIDJydsth7yr4ZfiMff4fgJof99l/m+6Rkmb06iMXXpq9BMhfNN
         IaYGFGmeRjtval/W44u2kkQYKjbhcwSGLuc1M=
Date: Mon, 22 Dec 2008 23:25:10 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: malc <av1474@comtv.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Lock-up on PPC64
Message-ID: <20081222222506.GA6014@joi>
References: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 09:18:07PM +0300, malc wrote:
> Hello,
>
> Synopsis
>
> Plain/non-root userspace application which doesn't interface with
> any weird out-of/in-tree drivers manages to lock-up a PS3 machine
> running Linux.
>
> The application in question is Mono VM running mcs.exe (C# compiler)
> which tries to compile particular file, distribution is Yellow Dog Linux
> 6.0 with either stock (2.6.23.x) or custom compiled (2.6.27) 64bit kernel.
>
>
> Symptoms are as follows (interaction is done via ssh from another
> machine):
>
> $ make
> ... lots of stdout/err messages
> ... eventually an error message
>
> Eventually the ssh session terminates, PS3 is still pingable but
> impossible to connect to, attaching keyboard and trying magic SysRq
> doesn't work, typing keys into login: prompt works (as in - the terminal
> shows keys that were pressed, but after hittiing enter the carret is
> advanced and nothing happens, hitting random keys doesn't yield anything
> either)

Check your RAM first (memtest). If it won't find anything please post your
config and dmesg. You can enable some debugging options ("Kernel hacking"
in menuconfig), setup netconsole and see if it can catch anything.
(see Documentation/networking/netconsole.txt)

Marcin
