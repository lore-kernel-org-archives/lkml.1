Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbXJAOI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbXJAOI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXJAOIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:08:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36955 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbXJAOIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:08:21 -0400
Date: Mon, 1 Oct 2007 07:06:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86_64 and AMD with C1E
Message-ID: <20071001070636.2d8e0f9f@laptopd505.fenrus.org>
In-Reply-To: <20071001130953.GC17357@one.firstfloor.org>
References: <20071001101532.025d652f@localhost>
	<p73r6kf6uwz.fsf@bingen.suse.de>
	<b70f2f960710010546k4658aa1ay466f243ac707c989@mail.gmail.com>
	<20071001130953.GC17357@one.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007 15:09:53 +0200

> There is normally a threshold above which you don't save significantly
> more power by doing less timer interrupts. You can test this 
> by doing the CONFIG_HZ=100 above.

however the point you're describing tends to more be around 25ms to
50ms.... HZ=100 is only a first rough test (and HZ=100 does have
userspace visibility, multimedia playback suffers due to the decreased
accuracy)
