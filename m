Return-Path: <linux-kernel-owner+w=401wt.eu-S935064AbZJOJCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935064AbZJOJCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934958AbZJOJCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:02:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36771 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934984AbZJOJCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:02:16 -0400
Date: Thu, 15 Oct 2009 10:03:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: git-commits-head@vger.kernel.org
Subject: Re: tty: use the new 'flush_delayed_work()' helper to do ldisc
 flush
Message-ID: <20091015100310.05cae5b6@lxorguk.ukuu.org.uk>
In-Reply-To: <200910142259.n9EMxaNb015265@hera.kernel.org>
References: <200910142259.n9EMxaNb015265@hera.kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     This way all flush_to_ldisc work is always done through the workqueues,
>     and we thus have a single point of serialization.
>     
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

What impact is this going to have on hardware that uses tty->low_latency
correctly and already queues stuff from its own processing work queue.
When we got double queueing before by accident we made some firmware
loading and similar tools run about half speed and completely hosed the
use of 8250 uart for MIDI work ?

Alan
