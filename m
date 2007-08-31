Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbXHaLaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbXHaLaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 07:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbXHaL35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 07:29:57 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37117 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755669AbXHaL34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 07:29:56 -0400
Date: Fri, 31 Aug 2007 10:42:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: possible build system oddity
Message-ID: <20070831084229.GE9260@stusta.de>
References: <200708311037.29280.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200708311037.29280.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 10:37:28AM +0200, Oliver Neukum wrote:
> Hi,
> 
> I only touched sound/usb/usbaudio.c
> Nevertheless the whole subtree und sound/ is recompiling. What's
> happening?

The only file that gets compiled (CC) should be sound/usb/usbaudio.c

It seems you are confused by the fact that this recompilation results in 
several relinks (LD)?

> 	Regards
> 		Oliver

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

