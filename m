Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbYIBANZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbYIBANZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 20:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYIBANS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 20:13:18 -0400
Received: from smtp2.ono.com ([62.42.230.20]:56414 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751383AbYIBANR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 20:13:17 -0400
Date: Tue, 2 Sep 2008 02:12:57 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Finding what is stuck...
Message-ID: <20080902021257.74344596@one.home>
In-Reply-To: <20080901170812.2c3b041b@infradead.org>
References: <20080902020447.5b48b083@one.home>
	<20080901170812.2c3b041b@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008 17:08:12 -0700, Arjan van de Ven <arjan@infradead.org> wrote:

> On Tue, 2 Sep 2008 02:04:47 +0200
> "J.A. Magallón" <jamagallon@ono.com> wrote:
> 
> > Hi all...
> > 
> > I'm running 2.6.27-rc5-git2 on an Aspire One.
> > The system is in general pretty responsive, but sometimes it just gets
> > totally stuck. Even the mouse stops. 
> > 
> > It looks related to disk (SSD) access, but I'm not totally sure.
> > Is there any way to find what is getting stuck ? I know that SSDs can
> > be slow on write, I don't mind if the system is faster or slower
> > (it's small :))), but if the speed is constant. That occasional
> > pauses are strange, like if SSD flushing gets stuck on BKL
> > (I know, no idea about what I talk...).
> > 
> > I'm using ext3 fs, noop iosched. But as I say, I'm not sure that the
> > disk writes are the culprit.
> > 
> > Any idea about how to find this ?
> 
> Have you tried to run "latencytop"?
> (you need to enable this in the kernel config as well)
> 
> it tends to (for me at least) point out very well where stalls happen,
> or at least, what the system is doing when they happen.
> 
> (hint: make sure you do "make install" before running it)
> 

Thanks, I'm a bit limited to distro kernels 'cause I don't want to build
my own kernel on the One, but I have just looked and Mandriva kernel is
built with LATENCYTOP=y. I will try that and report...

-- 
J.A. Magallon                       \                     Software is like sex:
                                     \               It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux kernel 2.6.23-jam01,  gcc version 4.2.2 20070909
