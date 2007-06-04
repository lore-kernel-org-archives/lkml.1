Return-Path: <linux-kernel-owner+w=401wt.eu-S1762622AbXFDXLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762622AbXFDXLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 19:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757623AbXFDXLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 19:11:12 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53868 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753917AbXFDXLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 19:11:12 -0400
Date: Tue, 5 Jun 2007 01:11:15 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: default charset for linux-kernel code?
Message-ID: <20070604231115.GG5500@stusta.de>
References: <20070604213645.GA18588@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070604213645.GA18588@uranus.ravnborg.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 11:36:45PM +0200, Sam Ravnborg wrote:
> In private mail I have discussed with a person the default charset
> to use for source code and in particular Kconfig files in the kernel.
> I recall to have seen some mails about UTF-8 but I would like to have
> confirmed what is the 'nofficial?' recommended charset for kernel code?

Everything that gets compiled into the kernel image (including printk()'s
but excluding comments) 7bit ASCII, the rest UTF-8.

For Kconfig files UTF-8 should be the right choice (assuming all
*config tools support it).

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

