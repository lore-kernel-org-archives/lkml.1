Return-Path: <linux-kernel-owner+w=401wt.eu-S933537AbXEVN7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbXEVN7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 09:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbXEVN7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 09:59:40 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41722 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755383AbXEVN7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 09:59:39 -0400
Date: Tue, 22 May 2007 15:59:27 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
Message-ID: <20070522135927.GA2098@stusta.de>
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 09:09:22AM -0400, Robert P. J. Day wrote:
> 
>   given that:
> 
> $ grep -r "define.*NORET_TYPE" *
> include/linux/ext4_fs.h:# define NORET_TYPE    /**/
> include/linux/linkage.h:#define NORET_TYPE    /**/
> include/linux/ext3_fs.h:# define NORET_TYPE    /**/
> $
> 
> is there any obvious value to the 30 or so uses of that macro
> sprinkled throughout the tree?

I can be mistaken, but it seems the uses should be replaced with your 
__noreturn

> rday

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

