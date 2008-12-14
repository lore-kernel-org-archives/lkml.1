Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYLNW61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYLNW61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 17:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYLNW6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 17:58:19 -0500
Received: from smtp2.ono.com ([62.42.230.20]:21519 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750983AbYLNW6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 17:58:18 -0500
Date: Sun, 14 Dec 2008 23:57:53 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Bugs on aspire one A150
Message-ID: <20081214235753.7cd11c51@werewolf.home>
In-Reply-To: <1229174138.24940.9.camel@maxim-laptop>
References: <491506DB.1070000@gmail.com>
	<1229174138.24940.9.camel@maxim-laptop>
X-Mailer: Claws Mail 3.6.1cvs75 (GTK+ 2.14.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008 15:15:38 +0200, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> 
> I also noticed, that now the SD only card reader is always enabled
> regardless of card been there while booting, and same happens in
> windows, I suspect that this is permanent hardware change, which worries
> me, but this reader works fine otherwise.
> (This is another reason why binary bioses are evil, go and find out why
> it enables it)
> 

Which BIOS ? Mine is 3304, kernel is 2.6.28-rc8, and LEFT card is not detected
unless I use this option:

options sdhci debug_quirks=1

I have downloaded BIOS 3308, but it is to big to fit in my 1.4 floppy image
(I still have a flooy image I dd on a USB flash, but have not managed to grow
it - wouldn't you know how to do it ?)


-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.27.5-desktop-1mnb (gcc 4.3.2 (GCC) #1 Sun Nov
