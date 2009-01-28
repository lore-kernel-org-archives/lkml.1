Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbZA1Xgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbZA1Xgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbZA1XgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:36:08 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:61635 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbZA1XgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:36:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NHZRvVabL2uC1gCugcTuUZWcCFAydjuf7cuKhg8PMCTM9OkAO89nFOqwhgSuAXllwl
         mXA1xPYA54G0rX/9mghZowlaUtEaA7wD4bXbAd7qkuJ6987t7NhRzClawT70G1A0mrKu
         PhSq0BdaPnMT45u1VPtw2zgxUz/MmBFzKyQYU=
Subject: Re: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4980E9DF.2070101@zytor.com>
References: <20090127222825.GA27097@elte.hu>
	 <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
	 <1233106614.3256.6.camel@localhost.localdomain>
	 <200901281337.52294.arnd@arndb.de>  <49809A65.2090501@kernel.org>
	 <1233170532.6717.49.camel@brick>
	 <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain>
	 <1233172994.6717.56.camel@brick>  <4980CD51.70601@zytor.com>
	 <1233179884.6717.59.camel@brick>  <4980D913.3000505@zytor.com>
	 <1233182314.6717.66.camel@brick>  <4980E9DF.2070101@zytor.com>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 15:36:04 -0800
Message-Id: <1233185764.5322.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 15:27 -0800, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> > 
> > Well, that's unfortunate, how about we just export the BSWAP version
> > unconditionally and hope pure i386 just goes away someday?
> > 
> 
> Well, we already have MOVBE coming up, too...
> 

Is someone already working on an __arch_swab{16|32|64}p to use them?

Harvey

