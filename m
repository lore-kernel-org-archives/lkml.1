Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYKKFCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYKKFCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 00:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbYKKFBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 00:01:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47528 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYKKFBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 00:01:50 -0500
Message-ID: <49191185.2000102@zytor.com>
Date: Mon, 10 Nov 2008 21:00:53 -0800
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
References: <20081104122839.GA22864@mailshack.com>  <20081104150729.GC21470@localhost>  <20081104170501.GE29626@one.firstfloor.org>  <1225822006.21441.1282961299@webmail.messagingengine.com>  <20081104204400.GC10825@elte.hu>  <1226243805.27361.1283784629@webmail.messagingengine.com>  <20081110085846.GG22392@elte.hu>  <1226321061.23701.1283927805@webmail.messagingengine.com>  <20081110130709.GA32613@elte.hu> <1226352907.25721.1284024167@webmail.messagingengine.com>
In-Reply-To: <1226352907.25721.1284024167@webmail.messagingengine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, after spending most of the day trying to get something that isn't
completely like white noise (interesting problem, otherwise I'd have
given up long ago) I did, eventually, come up with something that looks
like it's significant.  I did a set of multiple runs, and am looking for
the "waterfall points" in the cumulative statistics.

http://www.zytor.com/~hpa/baseline-hpa-3000-3600.pdf

This particular set of data points was gathered on a 64-bit kernel, so I
didn't try the segment technique.

It looks to me that the collection of red lines is enough to the left of
the black ones that one can assume there is a significant effect,
probably by about a cache miss worth of time.

	-hpa

