Return-Path: <linux-kernel-owner+w=401wt.eu-S1752256AbXBXMtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbXBXMtD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 07:49:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbXBXMtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 07:49:03 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37805 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752256AbXBXMtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 07:49:01 -0500
Date: Sat, 24 Feb 2007 13:52:52 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Stephen Dolan" <stedolan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Memory sharing question
Message-ID: <20070224135252.21caa191@lxorguk.ukuu.org.uk>
In-Reply-To: <1eff86fb0702240350l2c111c2apb5639fec67b360b4@mail.gmail.com>
References: <1eff86fb0702240350l2c111c2apb5639fec67b360b4@mail.gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> with the address as the "start" parameter and MAP_FIXED. However, that
> tends to fail, and MAP_FIXED can have annoying side-effects (killing
> off other mappings).

MAP_FIXED requires you know in advance a good place to put the memory,
which isn't too hard with some planning but does get fairly platform
specific and requires good knowledge.

> The point of all this is that I want to pass a large, complex (full of
> pointers) data structure to a different process, and I don't want the
> overhead of serialising it down a socket and then parsing it at the
> other end (the data structure's pretty big, and the other process
> won't need it all). Is this possible?

You can also just use relative pointers, which is actually pretty fast on
most modern processors
