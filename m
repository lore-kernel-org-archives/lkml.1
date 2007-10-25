Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbXJYRfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbXJYRfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbXJYRfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:35:37 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:32871 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752341AbXJYRfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:35:36 -0400
Date: Thu, 25 Oct 2007 19:36:05 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, glommer@gmail.com
Subject: Re: [PATCH] Wipe out traditional opt from x86_64 Makefile
Message-ID: <20071025173605.GM30533@stusta.de>
References: <11933164723812-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <11933164723812-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 09:47:52AM -0300, Glauber de Oliveira Costa wrote:
> Among other things, using -traditional as a gcc option stops us from
> using macro token pasting, which is a feature we heavily rely on.
> 
> There was still a use of -traditional in arch/x86/kernel/Makefile_64,
> which this patch removes.
> 
> I don't see any problems building kernels in my x86_64 box without
> -traditional.
>...

Does it also work with gcc 3.2 ?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

