Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbXELFcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbXELFcr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 01:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXELFck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 01:32:40 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34648 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbXELFcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 01:32:39 -0400
Message-ID: <46455168.6080904@zytor.com>
Date: Fri, 11 May 2007 22:32:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: pradeep singh <p.singh.rautela@gmail.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jonathan Corbet <corbet@lwn.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful", take 2
References: <6143.1178828419@lwn.net>	 <Pine.LNX.4.61.0705102326470.6426@yvahk01.tjqt.qr>	 <46439284.6080901@zytor.com>	 <Pine.LNX.4.61.0705112333320.9570@yvahk01.tjqt.qr>	 <4644E469.8000603@zytor.com> <64026d4a0705112157p75d76956g40455c7402b096d6@mail.gmail.com>
In-Reply-To: <64026d4a0705112157p75d76956g40455c7402b096d6@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pradeep singh wrote:
> 
> Sorry, for my misunderstanding but i hope Jonathan actually means
> volatile harmful only in C and not while using extended asm with gcc? Or
> does you all consider volatile while using extended asm as harmful too?
> Incidentally i came to know that using volatile in such cases may be
> still be optimized by the gcc. And the correct way is to fake a side
> effect to the gcc, which can be done using "memory" clobbering directive
> in the correct place and not "m" or "+m".
> 
> Does this means to exclude volatile from extended asm also, while using
> them in kernel?
> 

We were talking about "register", not "volatile".

	-hpa
