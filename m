Return-Path: <linux-kernel-owner+w=401wt.eu-S932414AbXAVT4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbXAVT4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbXAVT4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:56:50 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45512 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbXAVT4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:56:49 -0500
Date: Mon, 22 Jan 2007 11:56:44 -0800
From: Andrew Morton <akpm@osdl.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: where to maintain userspace daemon for line discipline
Message-Id: <20070122115644.b538908f.akpm@osdl.org>
In-Reply-To: <45AE507E.3040601@imap.cc>
References: <45AE507E.3040601@imap.cc>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 17 Jan 2007 17:36:14 +0100 Tilman Schmidt <tilman@imap.cc> wrote:
> The recent discussion on LKML convinced me that a line discipline
> is the correct way to layer a driver over a serial interface.
> This means, however, that I'll need a (trivial) userspace daemon
> which will hold the serial interface open after pushing the line
> discipline onto it.
> 
> Which raises the question: Where can I drop the source for that
> daemon so that it is
> a) maintained together with the line discipline in case a kernel
> developer feels the need to change something and
> b) picked up by distributions so that they don't end up shipping
> the line discipline without the necessary daemon?
> 
> Is there an appropriate place in or near the kernel tree for
> stuff like that?

Nope.  The requirement arises regularly.

util-linux would seem to be a suitable place, but apparently there
are, umm, isues surrounding that.
