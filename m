Return-Path: <linux-kernel-owner+w=401wt.eu-S1763661AbYD1AB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763661AbYD1AB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYD1ABT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:01:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:50196 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYD1ABT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:01:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YEchaS8BXaaiuMSKU+UR2LP/wpXUS3AoNaFlNG33pKRuURftkV7f9wPHx5VydSwJ087LH+4ERj+6wNVAqiMrPn8SXD0UUWuAl6mqYsKwCKO2waX8u3LhAQ/e7OZF9A3ivJ7oTYNx2W3L4SlgaI+qiOZFBkQo8wsbULj1O2n/8Us=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: x86: 4kstacks default
Date: Mon, 28 Apr 2008 02:00:20 +0200
User-Agent: KMail/1.8.2
Cc: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>, David Chinner <dgc@sgi.com>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804280102.01964.vda.linux@googlemail.com> <48150776.4080409@sandeen.net>
In-Reply-To: <48150776.4080409@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804280200.20818.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008 01:08, Eric Sandeen wrote:
> >>>> Why xfs code is said to be 5 times bigger than e.g. reiserfs?
> >>>> Does it have to be that big?
> >>> If we cut the bulkstat code out, the handle interface, the
> >>> preallocation, the journalled quota, the delayed allocation, all the
> >>> runtime validation, the shutdown code, the debug code, the tracing
> >>> code, etc, then we might get down to the same size reiser....
> >> Just noticed this bit of FUD. Last time I did some static analysis on
> >> stack usage, reiserfs alone would blow away 3k, while xfs was somewhere
> >> below.
> > 
> > I'm sorry, but it's not what I said.
> > I didn't say reiserfs eats less stack. I don't know.
> > I said it is smaller.
> > 
> > reiserfs/*  821474 bytes
> > xfs/*      3019689 bytes
> 
> FWIW, the reason for that is in large part all the features Dave listed
> above, and probably more.
> 
> And, while certainly not yet tiny, the recent trend actually is that xfs
> is getting a bit smaller:
> 
> http://oss.sgi.com/~sandeen/xfs-linedata.png

~30% line count reduction? Impressive, especially in this age
of creeping bloat. Thanks.
--
vda
