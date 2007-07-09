Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbXGIWaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbXGIWaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbXGIW34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:29:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:8273 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbXGIW3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JsLZroXhlYo3fmVS/UinBnKJL0H62GipoCDZ+jy9Gz2il8MTaemphiymtCBFky+I78KHWR804pKnpl2/4FPMqLF36GT2AZhDHdc39RLvgbEPm5zrEbIP1nofCkcXgfEY2ipvcQILP123KOOcWubZpP+QLp9X2uNLNzsbOxi9jUM=
Message-ID: <9a8748490707091529j153d7202s47596b78b7aac612@mail.gmail.com>
Date: Tue, 10 Jul 2007 00:29:54 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Charles Shannon Hendrix" <shannon@widomaker.com>
Subject: Re: BUG: kernel crash report, odd...
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9a8748490707091519g3a0a098dx1e9188083c5a74b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070709220848.GA6782@widomaker.com>
	 <9a8748490707091519g3a0a098dx1e9188083c5a74b4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot a few things, see below...

On 10/07/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> On 10/07/07, Charles Shannon Hendrix <shannon@widomaker.com> wrote:
> >
> > A system I was using a few minutes ago dumped this to the syslog:
> >
> > Jul  9 17:50:38 daydream kernel: [76022.613000] BUG: unable to handle
> > kernel NUL
> > L pointer dereference at virtual address 00000010
> > Jul  9 17:50:38 daydream kernel: [76022.613000]  printing eip:
> > Jul  9 17:50:38 daydream kernel: [76022.613000] c01ace66
> > Jul  9 17:50:38 daydream kernel: [76022.613000] *pde = 00000000
> > Jul  9 17:50:38 daydream kernel: [76022.613000] Oops: 0000 [#1]
> >
> >
> > There was no other information either before or after.
> >
> > What I saw was my KDE desktop stopped responding to events.
> >
> > Machine didn't respond to power switch.
> >
> > Unfortunately, that's all I know.
> >
> > In the past when I had bugs like this, I got a fairly extensive kernel
> > error message, but this time the above is the only thing I saw.
> >
> It does look a little short... probably the rest just didn't make it to disk...
>
> > I have not had kernel bugs like this until I started running 2.6.20 on a
> > new Kubuntu install.
> >
> > Same hardware, but Slackware and my own custom 2.6.19 kernel never
> > crashed.
> >
> Different kernel source version, different configuration, probably
> different compiler, Slackware doesn't patch the vanilla kernel - I
> believe (k)ubuntu does.   All in all that equals a significantly
> different kernel binary you have been running in those two cases.
>
A different userspace could also be the cause. In theory, userspace
should never be able to crash the kernel, but in real life bugs happen
and sometimes userspace manages to cause a kernel crash. So, a
different userspace environment in your new distribution could in
theory expose a bug that didn't surface with your previous
distribution.

> > Is there anything I can do, in case this happens again, to try and
> > capture more information?
> >
> 0. Make sure the kernels loglevel is set so that you get all messages.
>
0.5. Perhaps increase the size of the kernels log buffer (the
LOG_BUF_SHIFT config option)

> 1. Make sure syslog is setup to capture all kernel messages, both
> errors, warnings, notices, debug messages etc.
>
> 2. If you can, check output of 'dmesg' instead of just what made it to syslog.
>
> 3. If you have a second PC, setup serial console or netconsole to
> capture kernel messages on that second box. This can sometimes capture
> messages that don't make it to disk.
>
> 4. Build a custom kernel with some (or all) of the debug options under
> the Kernel Hacking menu enabled.
>
> 5. Even when the system hangs you may in some cases be able to get
> some info (or just sync the disks and do a reboot) via magic sysrq.
>

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
