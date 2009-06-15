Return-Path: <linux-kernel-owner+w=401wt.eu-S1763325AbZFOQao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763325AbZFOQao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763204AbZFOQab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:30:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762914AbZFOQaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:30:30 -0400
Date: Mon, 15 Jun 2009 09:29:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Liam Girdwood <lrg@slimlogic.co.uk>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] voltage regulator updates for 2.6.31-rc1
In-Reply-To: <1245065061.21421.90.camel@vega.slimlogic.co.uk>
Message-ID: <alpine.LFD.2.01.0906150927390.3305@localhost.localdomain>
References: <1245065061.21421.90.camel@vega.slimlogic.co.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, Liam Girdwood wrote:
>
>  drivers/regulator/lp3971.c                   |  562 ++++++++++++++++++++++++++
>  include/linux/regulator/lp3971.h             |   51 +++

So I really don't like this.

Why the heck would "lp3971.h" be under "include/linux"? That makes no 
sense what-so-ever. 

Why isn't it just

	drivers/regulator/lp3971.c
	drivers/regulator/lp3971.h

instead? There is never any reason for anything but the lp3971 driver to 
include its own header file, they should _not_ be split up to be in two 
different places.

In fact, why do we have a "include/linux/regulator/" at all? Does anybody 
else ever care? I doubt it.

Anyway, I pulled it, but I think this needs to be fixed. 

		Linus

