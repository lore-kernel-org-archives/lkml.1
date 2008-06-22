Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYFVUkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYFVUkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbYFVUkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:40:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754062AbYFVUkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:40:43 -0400
Date: Sun, 22 Jun 2008 13:36:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bernhard Walle <bwalle@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 4/5] x86: use BOOTMEM_EXCLUSIVE on 32-bit
In-Reply-To: <20080622203047.GC20800@suse.de>
Message-ID: <alpine.LFD.1.10.0806221336010.2926@woody.linux-foundation.org>
References: <20080622185327.348377223@mini.kroah.org> <20080622190131.GB20141@suse.de> <87prq9dxst.fsf@skyscraper.fehenstaub.lan> <20080622203047.GC20800@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Jun 2008, Greg KH wrote:
>
> > You will also need the patch from http://lkml.org/lkml/2008/6/21/103 to
> > make sure reserve_bootmem() is not void (*)().
> 
> Ok, let me know when that goes into Linus's tree please.

It already is: 71c2742f5e6348d76ee62085cf0a13e5eff0f00e.

		Linus
