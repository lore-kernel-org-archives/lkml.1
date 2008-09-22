Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbYIVNUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbYIVNUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYIVNUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:20:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbYIVNUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:20:01 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, dhowells@redhat.com
Subject: Re: netconsole and a serial one
References: <9e4733910809211714j5d79592cj162f8be4ecebaa78@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 22 Sep 2008 09:19:57 -0400
In-Reply-To: <9e4733910809211714j5d79592cj162f8be4ecebaa78@mail.gmail.com>
	(Jon Smirl's message of "Sun, 21 Sep 2008 20:14:34 -0400")
Message-ID: <x498wtkl3lu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jon Smirl" <jonsmirl@gmail.com> writes:

> I have both netconsole and a serial console setup on an embedded
> system. This is what I need for the boot process.
>
> After I'm booted I want to turn off printk() output to the serial
> console but keep it going to netconsole.
> I've been googling for an hour, how do I do this?
>
> I need to turn off the serial output after boot because serial
> printk() disables interrupts for up to 1ms which is enough to cause me
> to lose a lot of other interrupts.

There's no way (that I know of) to do this presently.  However, I think
David Howells has been working on a patch that reduces the amount of
time printk spends with IRQs disabled.

David?

Cheers,

Jeff
