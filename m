Return-Path: <linux-kernel-owner+w=401wt.eu-S933322AbXCMVFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322AbXCMVFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933340AbXCMVFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:05:19 -0400
Received: from gw.goop.org ([64.81.55.164]:36387 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322AbXCMVFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:05:17 -0400
Message-ID: <45F71207.8050605@goop.org>
Date: Tue, 13 Mar 2007 14:05:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Rik van Riel <riel@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Daniel Walker <dwalker@mvista.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] Sched clock paravirt op fix.patch
References: <200703020254.l222sOaM009656@zach-dev.vmware.com>	<20070313140129.GB92373@muc.de> <45F6C2A3.4040305@goop.org>	<20070313160709.GH10574@sequoia.sous-sol.org>	<20070313161656.GA12128@muc.de> <45F6D361.8080106@redhat.com> <20070313205628.GB46469@muc.de>
In-Reply-To: <20070313205628.GB46469@muc.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> It depends -- under heavy network load you can spend a long time
> just processing interrupts.

Well, in that case you probably don't want to charge them to the process
which happens to be running at the time.

    J

