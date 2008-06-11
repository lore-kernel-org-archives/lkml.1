Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYFKJgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYFKJgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 05:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbYFKJgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 05:36:12 -0400
Received: from hope.ime.usp.br ([143.107.45.8]:53666 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753402AbYFKJgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 05:36:12 -0400
Date: Wed, 11 Jun 2008 06:36:05 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       rbrito@ime.usp.br
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080611093605.GA13557@ime.usp.br>
References: <20080601193000.GA3056@ime.usp.br> <200806081242.54896.IvDoorn@gmail.com> <20080608213513.GA30499@ime.usp.br> <200806090002.17938.IvDoorn@gmail.com> <20080609001540.GA19072@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080609001540.GA19072@ime.usp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ivo and John.

I don't know if you received my earlier message.

On Jun 08 2008, Rogério Brito wrote:
> Correction here: I just went to the ia32 notebook again and, now, running
> Ubuntu's hardy kernel (which is a patched 2.6.24 kernel, AFAIK---yes, it
> is; just checked it) I could make the D-Link stick work fine.

The only problem that I had is that I had to reissue the command "iwconfig
wlan0 ap any" or, otherwise, the connection with the AP would be dropped (I
can get a log for you to peruse, if you wish).

> On Jun 09 2008, Ivo van Doorn wrote:
> > That is most unfortunate, since register dumps are usually most usefull
> > when I can compare the actual register values between a working and
> > non-working setup.  However I just realized I had a D-Link stick
> > myself, and apparently I have the exact same model/type. I'll compile a
> > 2.6.26-rc5 kernel and see if that stick works for me, if so, I have the
> > working register dump. And if not, then we can rule out endian
> > problems.
> 

Oh, these endianness problems are a headache. I just fixed some in one
small program in lame (the MP3 compressor), but in the end, I finally
won. :-)

Anyway, did you have some time to check your D-Link stick? I am willing to
test more things or other kernel trees, if that is helpful to the project.


Regards, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
