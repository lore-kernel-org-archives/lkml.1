Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab0CABOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 20:14:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:34346 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab0CABOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 20:14:18 -0500
Date: Sun, 28 Feb 2010 17:16:30 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] PCI changes for 2.6.34
Message-ID: <20100228171630.071840a2@infradead.org>
In-Reply-To: <4B8AF121.2060106@kernel.org>
References: <20100226093957.7b99d09c@jbarnes-piketon>
	<alpine.LFD.2.00.1002281227300.3851@localhost.localdomain>
	<alpine.LFD.2.00.1002281246120.3637@localhost.localdomain>
	<33223F6C-10BD-4671-937D-6D5E4956DD3F@kernel.org>
	<alpine.LFD.2.00.1002281314110.3637@localhost.localdomain>
	<4B8AF121.2060106@kernel.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Feb 2010 14:41:37 -0800
> 
> that trigger the reallocating...

btw we should never ever reallocate if the original layout was anywhere
near remotely sane. Doing that will cause many issues due various
craptastic bioses assuming things are where the bios put it.....
(and other operating systems also normally don't move bars etc unless
things are really b0rked)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
