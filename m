Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbYFTT6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbYFTT6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYFTT6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:58:22 -0400
Received: from smtpout10.uol.com.br ([200.221.4.201]:59392 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751756AbYFTT6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:58:22 -0400
Date: Fri, 20 Jun 2008 16:58:15 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       rbrito@ime.usp.br
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
	(fwd)
Message-ID: <20080620195815.GA2703@ime.usp.br>
References: <20080620175729.GA3151@ime.usp.br> <200806202048.47239.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806202048.47239.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: 6c54129a85d647e3244949d756fc0970
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ivo. Thank you for your reply.

On Jun 20 2008, Ivo van Doorn wrote:
> Hi,
> 
> > Did you receive my earlier message (attached here for reference)? I'm
> > willing to experiment with the driver a little bit and I hope that the
> > information that I have provided so far is helpful to chase the reason
> > why the driver doesn't work on PowerPC.
> 
> Sorry I have been quite busy with other things.

I'm terribly sorry for that, since I would like the driver to work with
the USB stick still in the 2.6.26 release (since that's what some
distributions will probably use).

> I have glanced over the register dumps, and there are no obvious
> endian problems.

OK.

> The reason most registers are different with the 16bits swapped is the way
> rt2x00 sends the register information through debugfs. rt2500usb only has 16bit
> registers and the way the information is dumped through debugfs assumes 32bit
> registers.

I didn't know that and was surprised. I thought that it would have been
something easier to fix, then.

> I will go over the real register differences as soon as possible, but
> as I said, I am momentarily quite busy with other things. :(

Thanks anyway. I am willing to help as much as I can.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
