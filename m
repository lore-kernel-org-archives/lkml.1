Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbXFDQim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbXFDQim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbXFDQie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:38:34 -0400
Received: from gw.goop.org ([64.81.55.164]:43679 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182AbXFDQid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:38:33 -0400
Message-ID: <46644002.8060008@goop.org>
Date: Mon, 04 Jun 2007 09:38:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>	 <20070601204141.f84ad72f.akpm@linux-foundation.org>	 <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>	 <20070601213117.1178e8e0.akpm@linux-foundation.org>	 <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>	 <84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com>	 <Pine.LNX.4.64.0706040916090.23191@schroedinger.engr.sgi.com>	 <84144f020706040922v56cb10eg5a730b4abe9d5251@mail.gmail.com>	 <alpine.LFD.0.98.0706040924070.23741@woody.linux-foundation.org> <84144f020706040937xb06535em543fa887ad65ee8f@mail.gmail.com>
In-Reply-To: <84144f020706040937xb06535em543fa887ad65ee8f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Then we might as well return your regular NULL pointer for zero-length
> allocations as you can't do anything sane with ZERO_SIZE_PTR either.

Round and round.  You can't distinguish NULL from allocation failure,
which kmalloc(0) decidedly *isn't*.

    J
