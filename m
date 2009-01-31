Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbZAaSnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbZAaSnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 13:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZAaSnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 13:43:42 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:60647 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbZAaSnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 13:43:42 -0500
Date: Sat, 31 Jan 2009 18:43:35 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
In-Reply-To: <1233182314.6717.66.camel@brick>
Message-ID: <alpine.LFD.1.10.0901311842140.16187@ftp.linux-mips.org>
References: <20090127222825.GA27097@elte.hu>  <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>  <1233106614.3256.6.camel@localhost.localdomain>  <200901281337.52294.arnd@arndb.de>  <49809A65.2090501@kernel.org>  <1233170532.6717.49.camel@brick> 
 <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain>  <1233172994.6717.56.camel@brick>  <4980CD51.70601@zytor.com>  <1233179884.6717.59.camel@brick>  <4980D913.3000505@zytor.com> <1233182314.6717.66.camel@brick>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Harvey Harrison wrote:

> Well, that's unfortunate, how about we just export the BSWAP version
> unconditionally and hope pure i386 just goes away someday?

 Or just emulate it alongside CMPXCHG and XADD? ;)

  Maciej
