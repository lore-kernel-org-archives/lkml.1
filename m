Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbZFWQzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbZFWQzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbZFWQyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:54:54 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:44871
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbZFWQyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:54:54 -0400
Message-ID: <4A4116FA.1060603@microgate.com>
Date: Tue, 23 Jun 2009 11:55:06 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink_gt fix transmit race and timeout
References: <1245181451.3727.5.camel@x2.microgate.com>	<20090622231937.2d32898e.akpm@linux-foundation.org>	<1245770161.3701.42.camel@x2.microgate.com> <20090623092739.5a8e9dd5.akpm@linux-foundation.org>
In-Reply-To: <20090623092739.5a8e9dd5.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I did have a couple of other comments on the patch which seem to have
> been missed?

Let's see, there was:
"It fails to explain the user-visible effects of the bug which was fixed."

On Tue, 23 Jun 2009 10:16:01 -0500 Paul Fulghum <paulkf@microgate.com> wrote:
> When all the DMA buffers are full,
> no further data is accepted from a user application calling
> write() until a timeout occurs and the transmitter and
> DMA controller are reset.

That addresses the user-visible effects.

Then there was:
"Those who need to make should-we-backport-this-to-stable
decisions need to know this. Often we are told, often we can guess."

My opinion on if this should be back ported to a stable branch:

Probably not. It effects a small minority of users
in rare instances with non-fatal consequences, just reduced
performance. Updated drivers for all 2.6 and 2.4 kernels are already
available on our website. If stable maintainers want to back port it
I'm all for it, but they are likely busy enough with critical changes.

-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982
(512)345-7791 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -5h)
www.microgate.com
