Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbYKVBCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbYKVBCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 20:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbYKVBBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 20:01:55 -0500
Received: from fizeau.zen.co.uk ([212.23.8.67]:33138 "EHLO fizeau.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbYKVBBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 20:01:54 -0500
X-Greylist: delayed 1088 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Nov 2008 20:01:54 EST
Subject: Re: [RFC][PATCH] sysrq-j: emergency shell
From: Matt Keenan <tank.en.mate@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20081121235159.GA15861@localhost.localdomain>
References: <20081121235159.GA15861@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 22 Nov 2008 00:42:16 +0000
Message-Id: <1227314536.29976.1.camel@bazbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost02-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-22 at 00:51 +0100, Vegard Nossum wrote:
> >From 57adfe62983db316fceba1b64258fd3d8830bcd8 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sat, 22 Nov 2008 00:25:57 +0100
> Subject: [PATCH] sysrq-j: emergency shell
> 
> This patch adds support for "SysRq-j", which invokes an emergency
> root shell in the current console.
> 
> Please don't bite my head off for abusing the file API; documentation
> was rather sparse! (Corrections are welcome, though.)
> 
> It seems that keyboard input will go to the shell only half of the
> time; the other half goes to whatever program was running there in
> the first place. I tried to kill the other users of the TTY using
> TIOCSCTTY, but it seems not to have worked. Any ideas?
> 

Have you considered SIGTSTP?

Matt


