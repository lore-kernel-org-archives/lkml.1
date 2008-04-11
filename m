Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbYDKNCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbYDKNCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 09:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbYDKNBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 09:01:55 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:60196 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbYDKNBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:01:54 -0400
Date: Fri, 11 Apr 2008 16:00:56 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Antonio =?utf-8?B?w4F2aWxh?= <aavilagallego@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Error using "make KBUILD_OUTPUT=path" or "make O=path"
Message-ID: <20080411130056.GA3821@cs181133002.pp.htv.fi>
References: <bdcb599c0804110514y7f07bd6aqfc3cb9ce6f52b08b@mail.gmail.com> <bdcb599c0804110538h6a9c0247vcfc0ae39dd55908a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bdcb599c0804110538h6a9c0247vcfc0ae39dd55908a@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 02:38:29PM +0200, Antonio Ávila wrote:
> First of all, I'd like to introduce myself, my name is Anthony and
> I've been using linux during the last 8 years.
> I have googled around and I haven't found anything so let's go to the question:
>  It seems that when initializing either KBUILD_OUTPUT or O variables
> (make KBUILD_OUTPUT="../build/" ) there is a problem, the output is
> effectivly working, but the problem is that some files (.config) that
> has been generated at the begining of the make process, are later used
> and as a  consecuence, the make is trying to read them as the file was
> created in the base path instead of $KBUILD_OUTPUT...
> 
> Or maybe I'm completely wrong about the using of that variables... :)
> I've attached an output log of the error.
> 
> More info:
> - The kernel has been configured
> - If I omit the O= or KBUILD_OUTPUT= initializations the kernel
> compiles wonderfull.
>...

You also have to give the O= to the make commandline when configuring 
the kernel - this will put the .config to the right place.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

