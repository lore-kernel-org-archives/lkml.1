Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbZDURoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbZDURoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbZDURoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:44:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755157AbZDURoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:44:19 -0400
Date: Tue, 21 Apr 2009 10:37:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David VomLehn <dvomlehn@cisco.com>
cc: David Woodhouse <dwmw2@infradead.org>,
       David Brownell <david-b@pacbell.net>, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
In-Reply-To: <20090421172929.GC8251@cuplxvomd02.corp.sa.net>
Message-ID: <alpine.LFD.2.00.0904211036140.2199@localhost.localdomain>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net> <20090421064346.GB8020@elte.hu> <200904210013.48551.david-b@pacbell.net> <1240333871.3632.70.camel@macbook.infradead.org> <20090421172929.GC8251@cuplxvomd02.corp.sa.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Apr 2009, David VomLehn wrote:
> 
> What in the world are users going to do when they see a message about
> output being lost? There is no way to recover the data and no way to
> prevent it in the future. I don't think this is a good approach.

Sure there is. The console messages are saved too, so doing 'dmesg' will 
get you all the data that was generated before the console went on-line.

We _already_ lose data in that sense (although we could replay it for the 
first console connected - maybe we even do, I'm too lazy to check).

			Linus
