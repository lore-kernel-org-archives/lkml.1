Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbYKNI4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbYKNI4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYKNI4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:56:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60355
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750729AbYKNI4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:56:36 -0500
Date: Fri, 14 Nov 2008 00:56:35 -0800 (PST)
Message-Id: <20081114.005635.131100777.davem@davemloft.net>
To: olafvdspek@gmail.com
Cc: jrm8005@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
From: David Miller <davem@davemloft.net>
In-Reply-To: <b2cc26e40811140051n4e821fddsc5504eedcccc9cdc@mail.gmail.com>
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
	<3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com>
	<b2cc26e40811140051n4e821fddsc5504eedcccc9cdc@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Olaf van der Spek" <olafvdspek@gmail.com>
Date: Fri, 14 Nov 2008 09:51:44 +0100

> On Fri, Nov 14, 2008 at 1:19 AM, J.R. Mauro <jrm8005@gmail.com> wrote:
> > On Wed, Nov 12, 2008 at 6:20 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> >> Hi,
> >>
> >> Quite often in discussions, I see people claiming Unix sockets are
> >> faster then TCP sockets on a connection that stays inside localhost.
> >
> > Unix domain sockets should be faster because they're not subject to
> > windowing, ACKs, flow control, encapsulation, etc. etc.
> 
> Why would you use windowing, ACKs, flow control and encapsulation on localhost?

So that you could firewall, shape, redirect, and make other
modifications to the traffic, as well as see it in tcpdumps.  That's
the power of Linux, and yes people do this stuff and yes people do
want these features to work over loopback.

> I expected the kernel to copy data directly from user-space of the
> sending process to a kernel buffer of the receiving process, much like
> UNIX sockets.

Then all of the above features and debugging facilities go away.
