Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYKJXhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYKJXhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 18:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYKJXgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 18:36:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40896 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYKJXgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 18:36:54 -0500
Message-ID: <4918C523.80609@zytor.com>
Date: Mon, 10 Nov 2008 15:34:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <1226243805.27361.1283784629@webmail.messagingengine.com> <20081110085846.GG22392@elte.hu> <491855AA.5060100@zytor.com> <1226353458.27999.1284030023@webmail.messagingengine.com>
In-Reply-To: <1226353458.27999.1284030023@webmail.messagingengine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> 
> I did the rdtsctest again for the irqstubs patch you sent. The data
> is at http://heukelum.fastmail.fm/irqstubs/ and the latency histogram
> is http://heukelum.fastmail.fm/irqstubs/latency_hpa.png
> 

Okay, I've stared at a bunch of different transformations of this data
and I'm starting to think that it's getting lost in the noise.  The
difference between your "idleticks" and "idleticks2" data sets, for
example, is as big as the differences between any two data sets that I
can see.

Just for reference, see this graph where I have filtered out events
outside the [30..1000] cycle range and renormalized.

	http://www.zytor.com/~hpa/hist.pdf

I don't know how to even figure out what a realistic error range looks
like, other than repeating each run something like 100+ times and do an
"eye chart" kind of diagram.

	-hpa
