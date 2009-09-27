Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZI0L5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZI0L5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 07:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbZI0L5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 07:57:33 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:45585 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbZI0L5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 07:57:32 -0400
Message-ID: <4ABF5328.8020901@upmc.fr>
Date: Sun, 27 Sep 2009 13:57:28 +0200
From: Bernard Pidoux <bernard.pidoux@upmc.fr>
Organization: Universite Pierre & Marie Curie - Paris 6
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.1 BUG #include <asm/bitsperlong.h>
References: <4ABF4E36.4090703@upmc.fr>
In-Reply-To: <4ABF4E36.4090703@upmc.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only file in asm-x86 directory is asm-offsets.h

This is a Mandriva 2009.1 Spring distro.
I checked that it was the same on two other machines with the same 
new installed distro.

I will copy bitsperlong.h into asm-x86 as suggested.

Should other files be present in the above directory ?

Should I send a bug report to Mandriva ?

Thank you all for your help.

Bernard Pidoux


On Sun, Sep 27, 2009 at 01:16:41PM +0200, Bernard Pidoux wrote:
> The problem is that when I compile an application that never caused any 
> problem before I get an error due to incorrect reference to 
> <asm/bitsperlong>
>
> This was due to int-ll64.h including <asm/bitsperlong.h> which does not exists.
>
> Is the correct solution to replace symbolic link ?
>
> /usr/src/linux/include/asm->asm-x86
>
> by
>
> /usr/src/linux/include/asm->asm-generic

The correct fix is to include the missing bitsperlong in
the asm-x86 directory.
In other words your kernel headers are broken.

Looking at latest kernel we do export bitsperlong.h.
So see if you can find a fix for your broken kernel headers.

	Sam

