Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbZLOEos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbZLOEos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZLOEor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:44:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054AbZLOEoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:44:46 -0500
Date: Mon, 14 Dec 2009 20:44:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Russ Dill <russ.dill@gmail.com>
cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.33-git
In-Reply-To: <alpine.LFD.2.00.0912142027440.14385@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912142043180.14385@localhost.localdomain>
References: <g383sjib9r8nlmw354UYAxe124vaj_firegpg@mail.gmail.com> <1260849652.28808.1.camel@russ-laptop> <alpine.LFD.2.00.0912142027440.14385@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Dec 2009, Linus Torvalds wrote:
> 
> Ok, this looks sane. I'll test it on the machine that had trouble.

Tests fine. I'd still like the trivial cleanup, but at least this confirms 
that the problem was that the original patch matches the wrong device due 
to not matching on the driver field.

Greg, do you want me to do this (revert+fixed patch), or are you going to 
send me a pull request with it all sorted out?

			Linus
