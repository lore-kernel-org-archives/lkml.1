Return-Path: <linux-kernel-owner+w=401wt.eu-S935878AbYEBUDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935878AbYEBUDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbYEBUDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:03:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:40418 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbYEBUDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:03:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S99TYTpHt/KUCayYkxAJ+6Slr7umeesrnys8A5ogS6jm2ztrqbSN/Ld+dyfvf7JFMPtqCY8R9U4qTTu33ksjR0xP6utyt+Pm57h32zVA4gPljFTkVn8dpqV0H36KK5tFwGXHcmtv6VCq5uE2H/qslN3n89EtusiPVi6PBVpg1qI=
Message-ID: <8dacd7b30805021303r558c238cs6dacaa0710858987@mail.gmail.com>
Date: Fri, 2 May 2008 22:03:00 +0200
From: "Jan Niklas Hasse" <jhasse@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata - DMA problems ICH7 rev 02
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080502135833.2248900e@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8dacd7b30805020437k2390d844ldd8909ebe11e9d56@mail.gmail.com>
	 <20080502135833.2248900e@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 at 2:58 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > my BIOS didn't support it), but none of them worked (every time my
>  > harddisk is loading my CPU is spammed with IOWait).
>
>  Then you must have a different problem ?

Maybe, but it seems as DMA isn't used. Everytime my hard disk is
reading/writing my system gets very slow. Here's the line when i run
top:

Cpu(s): 12.6%us,  5.4%sy,  0.0%ni,  6.5%id, 74.2%wa,  0.5%hi,  0.8%si,  0.0%st

The thing I mean is "wa".

>  > Output of uname -a and lspci is attached.
>  >
>  > I hope you can help me, very hard to work without DMA.
>
>  Please send the output of "dmesg" after boot

Okay, I pasted it here: http://rafb.net/p/KiWhqE72.html
