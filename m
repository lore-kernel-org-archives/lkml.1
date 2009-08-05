Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbZHEAr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbZHEAr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbZHEAr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:47:56 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:35496 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932315AbZHEArz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:47:55 -0400
Message-ID: <4A78D6BD.3030003@lougher.demon.co.uk>
Date: Wed, 05 Aug 2009 01:47:57 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Albin Tonnerre <albin.tonnerre@free-electrons.com>, sam@ravnborg.org,
       hpa@zytor.com, linux@arm.linux.org.uk, alain@knaff.lu,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: [PATCH 1/6] lib/decompress_*: only include <linux/slab.h> if
 STATIC is not defined
References: <20090731093107.GA29704@merkur.ravnborg.org>	<1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com> <20090804155500.db6c88fa.akpm@linux-foundation.org>
In-Reply-To: <20090804155500.db6c88fa.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon,  3 Aug 2009 16:58:16 +0200
> Albin Tonnerre <albin.tonnerre@free-electrons.com> wrote:
> 
>> These includes were added by 079effb6933f34b9b1b67b08bd4fd7fb672d16ef to
>> fix the build when using kmemtrace. However this is not necessary when
>> used to create a compressed kernel, and actually creates issues (brings
>> a lot of things unavailable in the decompression environment), so don't
>> include it if STATIC is defined.
>>
> 
> The description "actually creates issues (brings a lot of things
> unavailable in the decompression environment)" is inadequate.  Please
> describe te problem this patch fixes more completely so that others
> (ie: me) can decide whether this patch is needed in 2.6.32, 2.6.31. 
> 2.6.30, ...
> 
> 
> This patch conflicts heavily with
> 
> http://userweb.kernel.org/~akpm/mmotm/broken-out/bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment.patch
> 
> 
> What should we do about that?


What do you normally do in this situation?  I'm happy to send a revised
bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment.patch
that would apply cleanly on-top of Alvin's patch, but, this will obviously
create dependencies on his patch being applied.

Phillip


