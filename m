Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbXFTL40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbXFTL40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 07:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbXFTL4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 07:56:19 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:34513 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751260AbXFTL4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 07:56:18 -0400
Message-ID: <467915DD.7020906@grupopie.com>
Date: Wed, 20 Jun 2007 12:56:13 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Satyam Sharma <satyam.sharma@gmail.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] remove usage of memmem from scripts/kallsyms.c
References: <4678013C.5090402@grupopie.com> <a781481a0706191147x72be6357vf0c83808b13174b8@mail.gmail.com> <200706200033.16708.vapier@gentoo.org>
In-Reply-To: <200706200033.16708.vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Tuesday 19 June 2007, Satyam Sharma wrote:
>> So we could remove the "#define _GNU_SOURCE" at the top
>> of scripts/kallsyms.c too, presumably? If not (i.e. if there are
>> more GNUisms left in that file anyway), then I'm not sure if we
>> really gain by the change.
> 
> yes, i believe this is true

I only tried in on x86 with my toolchain and it works, but I don't know 
if it is worth the risk of breaking someone's setup for virtually no gain...

-- 
Paulo Marques - www.grupopie.com

"God is real, unless declared integer."
