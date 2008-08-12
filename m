Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYHLW2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYHLW2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYHLW1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:27:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57193 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751629AbYHLW1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:27:49 -0400
Date: Tue, 12 Aug 2008 23:10:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080812231008.7e2f8c6c@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0808121516180.3462@nehalem.linux-foundation.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk>
	<87ej4u9nf5.fsf@devron.myhome.or.jp>
	<alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org>
	<87proe81c1.fsf@devron.myhome.or.jp>
	<alpine.LFD.1.10.0808121303510.3462@nehalem.linux-foundation.org>
	<20080812224730.0e668dee@lxorguk.ukuu.org.uk>
	<alpine.LFD.1.10.0808121516180.3462@nehalem.linux-foundation.org>
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

> of EOVERFLOW are totally hidden by just distro differences over time. If 
> the binary I had hadn't been statically linked, I wouldn't have had a 
> chance, I suspect.

Libc 2 still worked as of early 2.6. I've not tried it more recently as I
recompiled rogue instead.

> (Of course, static linking wasn't exactly unusual for really old binaries)

Important ones anyway as you needed the exact matching libc.
