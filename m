Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbYHGRBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbYHGRBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbYHGRBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:01:33 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:45011 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYHGRBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:01:32 -0400
Date: Thu, 7 Aug 2008 14:01:21 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080807170121.GA5774@ime.usp.br>
References: <20080620175729.GA3151@ime.usp.br> <20080620195815.GA2703@ime.usp.br> <20080625194937.GA13636@ime.usp.br> <200808041526.08332.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200808041526.08332.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ivo, John and others.

On Aug 04 2008, Ivo van Doorn wrote:
> Rogério Brito wrote:
> > Just for your information, I just compiled the -rc7 kernel on x86-64
> > (where rt2500usb works if I boot with kernel 2.6.25) and still
> > doesn't work (I'm not even mentioning here PowerPC).
> 
> I have found the problem and have send it upstream so the patch should
> be present in 2.6.27.

Thanks for your e-mail. Indeed, I just compiled a 2.6.27-rc2 kernel and
it worked fine on x86-64 at least, which is a good thing. The only small
problem that I see is that the activity led doesn't blink when the
interface is sending or receiving data.

Regarding PowerPC, unfortunately, my iBook's battery died and I will get
a replacement to it (as soon as I can afford it). I also have yet to
find some time to compile a kernel for it, but I am happy to report the
results that I get (compiling the kernel will be easy, but installing on
it will take me some time as my Linux installation on it seems to be
messed up).

> Note that I am not going to push it to 2.6.26 since I don't know if
> the patch will cause problems in other parts of the driver.

Ok, I see it. There were lots of changes in mac80211 too, from a quick
glance at the patch.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
