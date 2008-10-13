Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbYJMIwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbYJMIwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbYJMIwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:52:14 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:38267 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbYJMIwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:52:13 -0400
Date: Mon, 13 Oct 2008 11:51:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Neshama Parhoti <pneshama@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: section mismatch with a platform driver
Message-ID: <20081013085111.GB29938@cs181140183.pp.htv.fi>
References: <912ec82a0810130119g795c91ffr1083d7e8459a6db1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <912ec82a0810130119g795c91ffr1083d7e8459a6db1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 10:19:05AM +0200, Neshama Parhoti wrote:
> Hi all,
> 
> I am working on a platform driver, and getting the following warning:
> 
> WARNING: vmlinux.o(.data+0x44bc4): Section mismatch: reference to
> .init.text:my_probe_func (between 'my_platform_struct' and
> 'debug_level_variable')
> 
> If I understand correctly, it shouts about my probe function being
> referenced from the data section:
> 
> static struct platform_driver my_platform_struct = {
> 	.probe		= my_probe,
> 	.remove		= my_remove,
> 	.suspend	= my_suspend,
> 	.resume		= my_resume,
> 	.driver		= {
> 		.name = DRIVER_NAME,
> 	},
> };
> 
> Why is that a problem ? Should I do something different ? Isn't my
> platform_driver struct completely standard ?

It complains about "my_probe_func", and that's not even in the code
you posted.

Please send the complete file.

> Thank You !
> Pnesh

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

