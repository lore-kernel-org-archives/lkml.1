Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962Ab0ADWV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0ADWV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813Ab0ADWVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:21:24 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55285 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753812Ab0ADWVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:21:23 -0500
Date: Mon, 4 Jan 2010 22:24:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Stefani Seibold <stefani@seibold.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/6] kfifo: add kfifo_out_peek
Message-ID: <20100104222429.6a386a88@lxorguk.ukuu.org.uk>
In-Reply-To: <20100104135754.07d4e442.akpm@linux-foundation.org>
References: <200912271003.631128760@firstfloor.org>
	<20091227210314.ABA04B17C3@basil.firstfloor.org>
	<1261950589.25298.32.camel@wall-e>
	<20091227234137.GD2399@basil.fritz.box>
	<20100104135754.07d4e442.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Macros are unpopular, for good reasons.  But the case for a
> template-based container such as this is a good one.  However I worry
> about the code bloat whcih the macro version might add.  We worry about
> all this later on.

Its really a special case for structs and fixed objects.

Bloat is going to be a big issue if its macro and all the serial/tty
stuff switches to it. Please keep the bytewise one none macro - even if
its a lib/foo.c file that simply uses the macros to produce the existing
new API.
