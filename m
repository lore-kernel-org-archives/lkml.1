Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbXEXMNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbXEXMNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbXEXMNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:13:46 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:55250 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbXEXMNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:13:45 -0400
Subject: Re: 2.6.21.1 fails to suspend/resume to disk (sort of)
From: Romano Giannetti <romanol@upcomillas.es>
To: Antonino Ingargiola <tritemio@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <5486cca80705240101u2fb6a954q53025752560f3ef7@mail.gmail.com>
References: <1179905115.7043.25.camel@localhost> 
	<200705231105.08408.rjw@sisk.pl> <1179914262.7043.56.camel@localhost> 
	<5486cca80705240101u2fb6a954q53025752560f3ef7@mail.gmail.com>
Content-Type: text/plain;
	charset=utf-8
Date: Thu, 24 May 2007 14:13:43 +0200
Message-Id: <1180008823.15600.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 10:01 +0200, Antonino Ingargiola wrote:
> Hi,
>
> 2007/5/23, Romano Giannetti <romano.giannetti@gmail.com>:
> [cut]
> > Uf, I will try to find the time. I am on my way to try to compile
> > 2.6.21.2 now. Problem is that a kernel compile "the ubuntu way" last
> > hours here. If there is an expert on make-kpkg here, I could use some
> > advise.

> Is not the ubuntu or debian way to take hours to compile. Is that you
> have to trim the config and enable the only modules you need for your
> hardware, then a rebuild cycle could last 10-15 min.

That is a problem, yes. But I was referring to the need of a make-kpkg
clean every time you recompile changing the EXTRAVERSION, wich forces a
make clean. I am trying to discover how to build manually and initramfs
that works...

>
> You will spend one hour once to cut down the configuration, but then
> you can reuse the .config for new kernels too with make oldconfig.
>

Yep, done that. The kernel does not boot (in the initramfs, there is
a /dev/hda1 but it refuses to mount; and yes, I have ext3 and ext2
compiled in, checked a lot of things, no joy. Will retry).

> To find the minimum configuration for you hardware use lspci -v,
> menuconfig help, and look at chapter 7 and 8 of Linux Kernel in a
> Nutshell:
>
> http://www.kroah.com/lkn/
>
> Also, pasting "lspci -n" output in the following page can be of some help:
>
> http://kmuto.jp/debian/hcl/
>
> Hope this helps.
>

What would be great is a tool that generate a config starting from the
lsmod list, to start from there and _enable_ more thing... but I know,
I'm dreaming.

Romano


--
Romano Giannetti --- romano.giannetti@gmail.com
Sorry for the following disclaimer, it's attached by our otugoing server
and I cannot shut it up.



--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

