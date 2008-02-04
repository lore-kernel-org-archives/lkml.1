Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbYBDCmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbYBDCmH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 21:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbYBDClz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 21:41:55 -0500
Received: from mail1.key-systems.net ([81.3.43.211]:53125 "HELO
	mail1.key-systems.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755290AbYBDCly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 21:41:54 -0500
Subject: Re: data corruption with dmcrypt/LUKS
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Milan Broz <mbroz@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-crypt@saout.de
In-Reply-To: <47A63AD3.6080501@redhat.com>
References: <1202050237.3200.33.camel@fermat.scientia.net>
	 <47A63AD3.6080501@redhat.com>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 01:43:49 +0100
Message-Id: <1202085829.3223.19.camel@fermat.scientia.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Milan Broz

On Sun, 2008-02-03 at 23:06 +0100, Milan Broz wrote:
> Are you sure, that your USB-stick is not faulty ?
I actually tested the stick, too. But I consider problems in the stick
(you mean the key-holding stick, do you?) as highly unlikely. 
If the key would be wrong a good crypto system should give me completely
different data and not just these "minor" faults.


> Could you reproduce it with different piece of hw ?
> (Several strange reports for dm-crypt over USB were identified to be 
> USB hw faults.)
I'll test it tomorrow.



> > 2) The second bug happens only rarely and leads to a panic.
> > Unfortunately it's difficult to reproduce, but it always happened when I
> > mkfs.ext3 on the /dev/mapper/sda2.
> > There's a stack-trace printed which clearly involves some dmcrypt
> > lines...
> But no stack trace attached here... please attach it.
Unfortunately I don't have one,... nothing was written to the logs and I
forgot to write it up :-/



> It can be known bug which was fixed in stable version some time ago
> see http://lkml.org/lkml/2007/7/20/211
Uhm but that patch should be part of 2.6.24, shouldn't it?


> No known bugs causing data corruption, no such reports so far
> for stable kernel.
Uhm ok,.. well as told above I'll make some other tests (without the
USB-sticks) but it would be great some people here could try this, too.

Best wishes,
Chris.

btw: What's about the dmcrypt mailing list,.. I've tried to subscribe
but no answers, and I get not posts (not even my owns).

