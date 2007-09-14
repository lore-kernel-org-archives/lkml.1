Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbXINXN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbXINXN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 19:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758546AbXINXNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 19:13:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55233 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512AbXINXNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 19:13:48 -0400
Message-ID: <46EB1599.4020806@zytor.com>
Date: Fri, 14 Sep 2007 16:13:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Kai Germaschewski <kai@germaschewski.name>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: Per option CFLAGS?
References: <46EB141A.7090200@gmail.com>
In-Reply-To: <46EB141A.7090200@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> Hi Kai, Sam.
> 
> I have a single file foo.c that I want to generate two (ALSA) modules
> from, snd-foo2000.ko and snd-foo2001.ko, by compiling with either
> FOO2000 or FOO2001 defined.
> 
> I can do this, and ALSA does this a few times, by providing dummy
> foo2000.c and foo2001.c files, like:
> 
> === foo2000.c
> #define FOO2000
> #include "foo.c"
> ===
> 
> and a regular Makefile
> 
> ===
> foo2000-objs := foo2000.o
> foo2001-objs := foo2001.o
> 
> obj-$(CONFIG_SND_FOO2000) += snd-foo2000.o
> obj-$(CONFIG_SND_F002001) += snd-foo2001.o
> ===
> 
> That #include is a little lame though. Is there a nicer way? I noticed
> the per-file CFLAGS, but given that it's one source file for both, that
> doesn't fit.
> 

The stub source file is usually considered a good way to do this.

	-hpa


