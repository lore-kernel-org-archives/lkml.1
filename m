Return-Path: <linux-kernel-owner+w=401wt.eu-S1759011AbYFGGif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011AbYFGGif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 02:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYFGGiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 02:38:25 -0400
Received: from smtps.uol.com.br ([200.221.4.131]:57912 "EHLO smtp.uol.com.br"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753112AbYFGGiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 02:38:24 -0400
Date: Sat, 7 Jun 2008 03:38:20 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] state of GEN_RTC vs rtc subsystem
Message-ID: <20080607063819.GA11623@ime.usp.br>
References: <484473E6.5060400@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <484473E6.5060400@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: b3fdc315a5fc0fc2bc0de5923762ca42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there.

On Jun 02 2008, Geoff Levand wrote:
> Geoff Levand wrote:
> > From what I can tell, those generic rtc routines the powerpc
> > arch provides are not properly hooked into the new rtc subsystem.
> > This causes problems for multi-platform builds where some platforms
> > must use gen_rtc, and some must the new rtc subsytem.
> 
> Just to follow up, I found that David Woodhouse has submitted
> a patch which does this:
> 
>    http://patchwork.ozlabs.org/linuxppc/patch?id=18139

This is nice, since I was just going to ask why my config file (put at
http://www.ime.usp.br/~rbrito/debug/config-2.6.26-rc4-4) has

(...)
# CONFIG_PPC_CLOCK is not set
(...)

Even if I force it to yes. When I run a "make oldconfig", it sets back
the PPC_CLOCK to not set. :-(

If anybody can explain what is going on (and how to correct it), I would
kindly appreciate it (and even generate some documentation on the
options, if I understand the issue it well enough).


Regards, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
