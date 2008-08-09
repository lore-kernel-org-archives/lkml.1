Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbYHIVEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbYHIVEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 17:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYHIVEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 17:04:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59135 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751314AbYHIVEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 17:04:36 -0400
Date: Sat, 9 Aug 2008 21:46:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       video4linux-list@redhat.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] V4L1: make PMS not auto-grab port 0x250
Message-ID: <20080809214657.3b5318d1@lxorguk.ukuu.org.uk>
In-Reply-To: <489DE890.1090103@keyaccess.nl>
References: <489DE890.1090103@keyaccess.nl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a PMS card. It was the hot technology of 199x about the same time
as doom came out. I'm probably the only person who still has one ;)

I'm going to NAK this however because passing in a port is a really dumb
interface. The PMS card can only be at port 0x250 so if you load it there
is no doubt and confusion involved.

The code is fine, the behaviour is correct. Ingo should fix his config
stuff.

Just apply a tiny bit of rational thought here. There is exactly ONE
Ingo. He's a smart cookie and can add exception lists to his tester.
There are millions of users some of whom are brilliant, others are not
computer wizards. The code should be optimised for them not for Ingo -
Ingo is an optimisation for the special case not the normal workload!

Alan
