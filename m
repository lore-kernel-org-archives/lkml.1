Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbYL3Tdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbYL3Tdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 14:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYL3Tdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 14:33:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46268 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbYL3Tdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 14:33:46 -0500
Date: Tue, 30 Dec 2008 17:33:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [GIT PATCHES for 2.6.28] V4L/DVB fixes, crash in
 af9005_usb_module_init()
Message-ID: <20081230173310.41711eb9@pedra.chehab.org>
In-Reply-To: <20081227171122.GA20147@localhost>
References: <20081224121252.7560391e@caramujo.chehab.org>
	<20081225081907.GA4628@elte.hu>
	<20081225212459.4c7e31b4@caramujo.chehab.org>
	<20081226090220.GF755@elte.hu>
	<20081226111324.3fbb804b@caramujo.chehab.org>
	<20081226132426.GA26953@elte.hu>
	<20081227164020.GA9726@elte.hu>
	<20081227171122.GA20147@localhost>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 27 Dec 2008 20:11:22 +0300
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Ingo Molnar - Sat, Dec 27, 2008 at 05:40:20PM +0100]
> | 
> | * Ingo Molnar <mingo@elte.hu> wrote:
> | 
> | > [...] I have re-enabled the driver in tip/master [...]
> | 
> | ok, just got this build failure:
> | 
> |  drivers/built-in.o: In function `dm1105_probe':
> |  dm1105.c:(.devinit.text+0x2298b): undefined reference to `cx24116_attach'
> |  make: *** [.tmp_vmlinux1] Error 1
> | 
> | config attached. Can test any fix patch.
> | 
> | 	Ingo
> |
> 
> Something like that?

I suspect that this will work. Could you please send your SOB?


Cheers,
Mauro
