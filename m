Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbYKNAWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbYKNAWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbYKNAWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:22:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57918
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756533AbYKNAWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:22:36 -0500
Date: Thu, 13 Nov 2008 16:22:33 -0800 (PST)
Message-Id: <20081113.162233.39564490.davem@davemloft.net>
To: jrm8005@gmail.com
Cc: olafvdspek@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
From: David Miller <davem@davemloft.net>
In-Reply-To: <3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com>
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
	<3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J.R. Mauro" <jrm8005@gmail.com>
Date: Thu, 13 Nov 2008 19:19:36 -0500

> On Wed, Nov 12, 2008 at 6:20 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> > Hi,
> >
> > Quite often in discussions, I see people claiming Unix sockets are
> > faster then TCP sockets on a connection that stays inside localhost.
> 
> Unix domain sockets should be faster because they're not subject to
> windowing, ACKs, flow control, encapsulation, etc. etc.

And the wakeup rate is higher for TCP, and our process scheduler has
been getting gradually slower and slower over time since 2.6.22
