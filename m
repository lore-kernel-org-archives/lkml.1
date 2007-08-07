Return-Path: <linux-kernel-owner+w=401wt.eu-S934332AbXHGOo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332AbXHGOo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXHGOoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:44:20 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:1963 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbXHGOoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:44:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=lx/6UJTuFBeGvxVtd12AuGb9GFoDfpCgRUFg95i+fxil+8hL9N49BFSt0+/HRvwM3l59blGY9e2TtGPA2sH/gpUFPKfSnmTIvtBLO2VqheJYc2hLfyKxGCRKsJUSfC5gddg/cF6N4mg72ggaRSTJGdNMoJ5ZnAzICTG5rZR724s=
Message-ID: <46B88506.8020107@googlemail.com>
Date: Tue, 07 Aug 2007 16:43:18 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Vincent Legoll <vincent.legoll@gmail.com>
CC: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.4.35 compilation failed in LVM
References: <4727185d0708070624q72f8660bif37074036c1401a5@mail.gmail.com>
In-Reply-To: <4727185d0708070624q72f8660bif37074036c1401a5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent Legoll wrote:
> Hello,

Hi,

> 
> I tried to get 2.4.35 to compile on a file server I manage, and got that:
> 
> gcc -D__KERNEL__ -I/usr/src/linux-2.4/include -Wall
> -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing
> -fno-common -fno-builtin-sprintf -fomit-frame-pointer
> -Wno-pointer-sign -pipe -mpreferred-stack-boundary=2 -march=i686
> -fno-unit-at-a-time -DMODULE -DMODVERSIONS -include
> /usr/src/linux-2.4/include/linux/modversions.h  -nostdinc -iwithprefix
> include -DKBUILD_BASENAME=lvm  -c -o lvm.o lvm.c
> lvm.c:397: error: static declaration of 'vg_count' follows non-static
> declaration
> lvm-internal.h:48: error: previous declaration of 'vg_count' was here
> 
> looking in the 2.4.35 patch, this has been modified, is there already
> a fix for that ?

Yes there is :

http://git.kernel.org/?p=linux/kernel/git/wtarreau/linux-2.4.git;a=commitdiff;h=0a1b1818b031b46e3755f12f5cff76df7a0661a8

 
