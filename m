Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbZFWRCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbZFWRCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761178AbZFWRC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:02:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761247AbZFWRCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:02:25 -0400
Date: Tue, 23 Jun 2009 10:02:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink_gt fix transmit race and timeout
Message-Id: <20090623100206.fac4dde7.akpm@linux-foundation.org>
In-Reply-To: <4A4116FA.1060603@microgate.com>
References: <1245181451.3727.5.camel@x2.microgate.com>
	<20090622231937.2d32898e.akpm@linux-foundation.org>
	<1245770161.3701.42.camel@x2.microgate.com>
	<20090623092739.5a8e9dd5.akpm@linux-foundation.org>
	<4A4116FA.1060603@microgate.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 11:55:06 -0600 Paul Fulghum <paulkf@microgate.com> wrote:

> Andrew Morton wrote:
> > I did have a couple of other comments on the patch which seem to have
> > been missed?
> 
> Let's see, there was:
> "It fails to explain the user-visible effects of the bug which was fixed."

I'm referring to

  Where did the "7" come from?

and

  I have a suspicion that tx_stop() should use del_timer_sync(), not
  del_timer().  What happens if the timer handler is concurrently
  running?

