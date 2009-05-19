Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbZESMcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbZESMcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZESMcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:32:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58614 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750778AbZESMcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:32:45 -0400
Date: Tue, 19 May 2009 13:32:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090519133206.173a2ddf@lxorguk.ukuu.org.uk>
In-Reply-To: <20090519122623.GD14305@elte.hu>
References: <4A0DFF78.6000501@goop.org>
	<20090515202250.0f1218ef@jbarnes-g45>
	<m1iqk1k708.fsf@fess.ebiederm.org>
	<4A10EAC4.9070701@goop.org>
	<20090518085902.GE10687@elte.hu>
	<4A11A3F8.1010202@goop.org>
	<20090519095918.GA11790@elte.hu>
	<4A12A46A02000078000017E1@vpn.id2.novell.com>
	<20090519110837.GA10548@elte.hu>
	<4A12A05C.6050004@redhat.com>
	<20090519122623.GD14305@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - or introduce its own hypercall API based administration API,
>   without bothering the guest kernel with crap. Trivially patch Xorg
>   to make use of it and that's it.

PCI pass through mixed with that isn't going to be fun and PCI pass
through is one area where a lot of the MTRR manipulation is meaningful
and valid (and can be handled for the guest).

I really don't see why rd/wrmsr processing isn't sufficient for this

Alan
