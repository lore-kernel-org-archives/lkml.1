Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbYFAXAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbYFAXAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYFAXAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:00:24 -0400
Received: from smtps.uol.com.br ([200.221.4.131]:51337 "EHLO smtp.uol.com.br"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752490AbYFAXAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:00:23 -0400
Date: Sun, 1 Jun 2008 19:58:29 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080601225829.GC3759@ime.usp.br>
References: <20080601193000.GA3056@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080601193000.GA3056@ime.usp.br>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: b94575dc55fbaf0fcafdcd8f3805cfad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there.

I just did some more tests and I would like to report them here.

On Jun 01 2008, Rogério Brito wrote:
> I have an iBook G3 600MHz combo (late 2001 model, powerpc) with a USB
> wireless card rt2x00 that doesn't work.

It seems that we have some problems with the USB card even on ia32:
after it is configured, I have to issue the command "iwconfig wlan0 ap any"
all the time so that I can be able to download anything or even resolve
names.

With a PCMCIA rt2500 adapter, I don't have such problems when running a
stock Ubuntu kernel from Hardy Heron.

So, it seems that the problem is a little deeper than just some
endianness thing to it.


Regards, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
