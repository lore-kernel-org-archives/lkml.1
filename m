Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYJUUf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYJUUf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYJUUfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:35:15 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:1509 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbYJUUfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:35:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MCTjxGechzQS6zsd5S76gY774mkgnuZj4x6kbj8ChM/QheBzkfpovc6AaClxmu50ca
         ru1hpNuqaqh8Z7VIusmnkIQS4i5Dsdftl5RcFRUT6vKpKoHDPp575IYYd9uHdDueUhTs
         5dS8Xy+cjiafQWvNZ62QuS9uZ6OgeIVDYdk5c=
Subject: Re: [PATCH 09/20] m68k: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0810212003530.8356@anakin>
References: <1224525138.31861.206.camel@brick>
	 <Pine.LNX.4.64.0810212003530.8356@anakin>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 13:35:02 -0700
Message-Id: <1224621302.5768.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 20:05 +0200, Geert Uytterhoeven wrote:
> On Mon, 20 Oct 2008, Harvey Harrison wrote:
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> > The final prerequisite patches to prevent breakage of headers-install and
> > usage of the swabb.h functions have gone into mainline, please move your arch
> > to the new header.
> > 
> > b8e465f4945bc0e9f324e3bbe15f5180a8e9a6fe byteorder: add new headers for make headers-install
> > acf0108a84edae22b99655eb2f6f6c9f7ec4d449 byteorder: use generic C version for value byteswapping
> > 1d8cca44b6a244b7e378546d719041819049a0f9 byteorder: provide swabb.h generically in asm/byteorder.h
> > 1a651a00e20fd4997f0b91258f6f95b7d96edcd9 byteorder: remove direct includes of linux/byteorder/swab[b].h
> > 

A hunk got lost, see mainline:


> commit f07767fd0f95c385108fa4c456a9cb216a424fec
> Author: Harvey Harrison <harvey.harrison@gmail.com>
> Date:   Mon Oct 20 10:23:38 2008 -0700
> 
>     byteorder: remove direct includes of linux/byteorder/swab[b].h
>     
>     A consolidated implementation will provide this generically through
>     asm/byteorder, remove direct includes to avoid breakage when the
>     changeover to the new implementation occurs.
>     
>     This hunk was lost from commit 1d8cca44b6a244b7e378546d719041819049a0f9
>     ("byteorder: provide swabb.h generically in asm/byteorder.h")
>     
>     Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Cheers,

Harvey

