Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbXFTPZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbXFTPZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbXFTPZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:25:44 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:54777 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330AbXFTPZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:25:43 -0400
In-Reply-To: <467915DD.7020906@grupopie.com>
References: <4678013C.5090402@grupopie.com> <a781481a0706191147x72be6357vf0c83808b13174b8@mail.gmail.com> <200706200033.16708.vapier@gentoo.org> <467915DD.7020906@grupopie.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <c8d2863984d16e31de2aaed038b7367a@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Mike Frysinger <vapier@gentoo.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] remove usage of memmem from scripts/kallsyms.c
Date: Wed, 20 Jun 2007 17:25:37 +0200
To: Paulo Marques <pmarques@grupopie.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> So we could remove the "#define _GNU_SOURCE" at the top
>>> of scripts/kallsyms.c too, presumably? If not (i.e. if there are
>>> more GNUisms left in that file anyway), then I'm not sure if we
>>> really gain by the change.
>> yes, i believe this is true
>
> I only tried in on x86 with my toolchain and it works, but I don't 
> know if it is worth the risk of breaking someone's setup for virtually 
> no gain...

With the memmem() removed, the code builds (and works)
fine on several non-GNU systems.  It should be perfectly
safe to remove the _GNU_SOURCE.  Perhaps you should
replace it with the proper POSIX_ define so it won't
be broken again?


Segher

