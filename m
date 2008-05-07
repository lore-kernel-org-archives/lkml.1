Return-Path: <linux-kernel-owner+w=401wt.eu-S1759778AbYEGOeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778AbYEGOeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbYEGOd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:33:59 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:55179
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbYEGOd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:33:57 -0400
Date: Wed, 7 May 2008 16:33:55 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Suspend to memory is freezing my machine
Message-ID: <20080507143355.GE8362@duo.random>
References: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 09:37:54AM +0200, Zdenek Kabelac wrote:
> Hello
> 
> With recent 2.6.25 & 2.6.26-rc1 git (around 1 week) I get occasionally
> complete freeze of my T61 during suspend. (dual core, 2GB).
> 
> I'm running kernel with no_console_suspend - but all I can see is
> blinking cursor on an empty screen - thus even when I run kernel with
> most debug options turned on, I can't pass more details so far.  I run
> suspend with with SD card in - so maybe some update in the MMC driver
> might be responsible for this ?
> 
> Also - I think that option no_console_suspend doens't work correctly -
> as many times with suspend I do not see any log message on my console
> screen. However sometimes the log is shown.

Same here. Suspend to ram crashes on resume starting in 2.6.25 (didn't
test 2.6.25-rc in my production system).

Because this isn't 100% reproducible bisecting may return false
negatives.
