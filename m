Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbXKCWhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbXKCWhe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 18:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbXKCWh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 18:37:26 -0400
Received: from gw.goop.org ([64.81.55.164]:53061 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbXKCWhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 18:37:25 -0400
Message-ID: <472CF806.9040004@goop.org>
Date: Sat, 03 Nov 2007 15:36:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [patch 0/4] ticket spinlocks for x86
References: <20071101140146.GA26879@wotan.suse.de>
In-Reply-To: <20071101140146.GA26879@wotan.suse.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Just for fun I also had a shot at merging the headers, as they become a
> lot more similar after this with the removal of the paravirt crud.

Glommer posted a set of patches the other day to implement x86-64
paravirt, which unifies lots of things including spinlocks.  But if
you've removed the need to diddle with sti/cli, then that works too...

    J
