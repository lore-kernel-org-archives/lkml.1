Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbYAGXfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbYAGXfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759115AbYAGXfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:35:01 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:59103 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759149AbYAGXe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:34:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RkuyXd2/R/83XnyXQYSsRSQT8mtgOQSXo1h/U3Bk/22WhiV6mw06CN/gnE9jj9J36jtwEbDIhNp8KeAm6nU1g1nWcje40+y9T/XPIB0pCtb/jmGIMEcVVfLh4zxN2b8ahC7cvAWEjlwZdpTk3fZM4QVWT3ozTHWhRfU1O52OmVU=
Message-ID: <9a8748490801071534h722840c5k957885e1754e9eaa@mail.gmail.com>
Date: Tue, 8 Jan 2008 00:34:56 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Stoyan Gaydarov" <stoyboyker@gmail.com>
Subject: Re: Kernel Oops?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6d291e080801071515wf7ebbccu744e3e3eca6bb0a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6d291e080801071515wf7ebbccu744e3e3eca6bb0a9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2008, Stoyan Gaydarov <stoyboyker@gmail.com> wrote:
> Today I upgraded my kernel from 2.6.23.9 to 2.6.23.12 and in the past
> 30 minutes I have had to restart my computer twice.
> I believe its a kernel oops or a kernel panic because when the
> computer freezes it blinks the caps and scroll lock LEDs.
> I don't know what is causing the problem but I am willing to help, I
> can provide you with any information you need.
> The only problem is that I don't know how to debug the system myself.
> If anyone can tell me what to do to I can do it and give back the
> information.
>

Here are some things for you to try :


Try looking in your log files. look for things like "Oops", "BUG()"
and similar. If you find anything that looks relevant, post it here.

If you can trigger the problem without X running - try that. Sometimes
an Oops makes it to the local console but doesn't make it to the logs.
Being logged into a plain console without X running when the problem
triggers can sometimes enable you to capture it with a digital camera.

Try building your kernel with magic sysrq support (if you haven't
already). Then you can sometimes manage to get a backtrace to the
console after the hang. See Documentation/sysrq.txt for details.

Try building your kernel with some (or all) of the debug options found
under the 'Kernel hacking' menuconfig menu to get more debug info.

Make sure you have no proprietary modules that taint your kernel
loaded (like the NVidia driver for example). The presence of any such
modules makes the kernel pretty much un-debugable.

If nothing makes it to your logs nor to your local console, then try
attaching a second PC via serial console or netconsole and see if you
can manage to log the Oops that way. See
Documentation/serial-console.txt and
Documentation/networking/netconsole.txt for details.


That should do it for a few starting points.  :-)


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
