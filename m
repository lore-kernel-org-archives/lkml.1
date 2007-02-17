Return-Path: <linux-kernel-owner+w=401wt.eu-S965254AbXBQMup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254AbXBQMup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 07:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965253AbXBQMup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 07:50:45 -0500
Received: from gockel.physik3.uni-rostock.de ([139.30.44.16]:16609 "EHLO
	gockel.physik3.uni-rostock.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965254AbXBQMuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 07:50:44 -0500
Date: Sat, 17 Feb 2007 13:50:43 +0100 (CET)
From: Tim Schmielau <tim@physik3.uni-rostock.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Move include linux/marker.h to kernel.h
In-Reply-To: <20070216104340.3c6f2eed.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.63.0702171345140.20161@gockel.physik3.uni-rostock.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
 <45D483D7.2040609@imap.cc> <20070215144142.0c13580a.akpm@linux-foundation.org>
 <20070215224656.GB6297@Krystal> <20070215154418.88edfcbc.akpm@linux-foundation.org>
 <20070216003739.GC9851@Krystal> <20070215172242.ab7a6f1e.akpm@linux-foundation.org>
 <20070216180513.GC14004@Krystal> <20070216104340.3c6f2eed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007, Andrew Morton wrote:

> No, that's still crufty.  There's no reason why marker.h needs special
> treatment whereas, say, jiffies.h does not (is there?)

Unforunately, even jiffies.h gets special treatment. sched.h still 
includes jiffies.h, as this is where it was originally defined.

I've had that on my to-do list for some years now, but unfortunately it 
will probably remain there for some more.
Somebody else who wants to check all files for properly including 
jiffies.h and then remove the include from sched.h?

Thanks,
Tim
