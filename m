Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbXINXHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbXINXHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 19:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbXINXHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 19:07:35 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:47828 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbXINXHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 19:07:35 -0400
Message-ID: <46EB141A.7090200@gmail.com>
Date: Sat, 15 Sep 2007 01:07:06 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kai Germaschewski <kai@germaschewski.name>,
       Sam Ravnborg <sam@ravnborg.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Per option CFLAGS?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kai, Sam.

I have a single file foo.c that I want to generate two (ALSA) modules from, 
snd-foo2000.ko and snd-foo2001.ko, by compiling with either FOO2000 or 
FOO2001 defined.

I can do this, and ALSA does this a few times, by providing dummy foo2000.c 
and foo2001.c files, like:

=== foo2000.c
#define FOO2000
#include "foo.c"
===

and a regular Makefile

===
foo2000-objs := foo2000.o
foo2001-objs := foo2001.o

obj-$(CONFIG_SND_FOO2000) += snd-foo2000.o
obj-$(CONFIG_SND_F002001) += snd-foo2001.o
===

That #include is a little lame though. Is there a nicer way? I noticed the 
per-file CFLAGS, but given that it's one source file for both, that doesn't fit.

Rene.
