Return-Path: <linux-kernel-owner+w=401wt.eu-S1423041AbXBUUJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423041AbXBUUJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423061AbXBUUJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:09:13 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:41203 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423041AbXBUUJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:09:12 -0500
Date: Wed, 21 Feb 2007 15:09:04 -0500
To: Mockern <Mockern@yandex.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cat problem in tiny_tty driver (the source included)
Message-ID: <20070221200904.GG22464@csclub.uwaterloo.ca>
References: <45DC5F34.000008.04893@tide.yandex.ru> <20070221151554.GA22466@csclub.uwaterloo.ca> <45DC9EA0.000007.11000@webmail18.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DC9EA0.000007.11000@webmail18.yandex.ru>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 10:33:52PM +0300, Mockern wrote:
> Thank you very much for you help.
> 
> BTW, for cat < /dev/my_tty1 can see here something wrong?
> as I understand tiny_timer function sends data to tty level
> by calling tty_flip_buffer_push(tty).
> 
> Is this enough to support cat < /dev/my_tty1?

I don't really know the tty layer very much.  I just saw a very obvious
bug in the code.

Does cat from the device give an error or does it just not do anything?

What does strace say for that?

--
Len Sorensen
