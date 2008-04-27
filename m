Return-Path: <linux-kernel-owner+w=401wt.eu-S1764873AbYD0XDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764873AbYD0XDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759708AbYD0XDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:03:02 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:56939 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbYD0XC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QmSJcL/M0/CAm7VMcp6HI5e3nykRJE8X9NkC8mTi3ppp6Q2sLeLBzC0BH4L44HImNXmvxFkxY0tziYtYbKQqiT5iwVVbol9EnhM2TuOmzvw6IADunCz8bMzEC1RKyk2fWYjk8OAAZJO58xOcVwx0Yhc/vsRRDhHmKaYuAXggY84=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: x86: 4kstacks default
Date: Mon, 28 Apr 2008 01:02:01 +0200
User-Agent: KMail/1.8.2
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <20080422012819.GT108924158@sgi.com> <20080427192736.GA21979@logfs.org>
In-Reply-To: <20080427192736.GA21979@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804280102.01964.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 April 2008 21:27, Jörn Engel wrote:
> On Tue, 22 April 2008 11:28:19 +1000, David Chinner wrote:
> > On Mon, Apr 21, 2008 at 09:51:02PM +0200, Denys Vlasenko wrote:
> > 
> > > Why xfs code is said to be 5 times bigger than e.g. reiserfs?
> > > Does it have to be that big?
> > 
> > If we cut the bulkstat code out, the handle interface, the
> > preallocation, the journalled quota, the delayed allocation, all the
> > runtime validation, the shutdown code, the debug code, the tracing
> > code, etc, then we might get down to the same size reiser....
> 
> Just noticed this bit of FUD. Last time I did some static analysis on
> stack usage, reiserfs alone would blow away 3k, while xfs was somewhere
> below.

I'm sorry, but it's not what I said.
I didn't say reiserfs eats less stack. I don't know.
I said it is smaller.

reiserfs/*  821474 bytes
xfs/*      3019689 bytes
--
vda
