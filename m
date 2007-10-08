Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbXJHWLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbXJHWLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbXJHWLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:11:42 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43117 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751889AbXJHWLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:11:41 -0400
Date: Tue, 9 Oct 2007 00:12:08 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc9 compile error drivers/video/fbmon.c
Message-ID: <20071008221208.GQ16424@stusta.de>
References: <470AA886.4070309@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <470AA886.4070309@aitel.hist.no>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 12:00:38AM +0200, Helge Hafting wrote:
>  CC      drivers/video/fbmon.o
> drivers/video/fbmon.c: In function ‘fb_parse_edid’:
> drivers/video/fbmon.c:867: error: expected ‘=’, ‘,’, ‘;’, 
> ‘asm’ or ‘__attrib
> _’ before ‘*’ token
> drivers/video/fbmon.c:867: error: ‘block’ undeclared (first use in this 
> func
> )
>
> This line reads:
>    unsigned char$*block;
>
> Source error, or is my tree simply corrupt?

The $ is a space character in my copy of the tree, so it seems to be a 
corrupted tree with a bit error on your side ($ and the space character 
differ by only one bit).

> Helge Hafting

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

