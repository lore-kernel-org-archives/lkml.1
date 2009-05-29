Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbZE2LCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbZE2LCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 07:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbZE2LCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 07:02:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:58986 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbZE2LCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 07:02:14 -0400
Subject: Re: [patch 13/96] JFFS2: fix mount crash caused by removed nodes
From: David Woodhouse <dwmw2@infradead.org>
To: anees a m <aneesgnu@gmail.com>
Cc: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <17cc26190905290126l8158b10t44ff0649feb5d7a9@mail.gmail.com>
References: <20090314000508.803142980@mini.kroah.org>
	 <20090314001449.GA4485@kroah.com> <20090314000740.633616698@mini.kroah.org>
	 <17cc26190905290126l8158b10t44ff0649feb5d7a9@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 12:02:06 +0100
Message-Id: <1243594926.19886.25.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 01:26 -0700, anees a m wrote:
> Iam uses JFFS2 filesystem for an embedded flash device. But when the
> power is removed i between, the JFFS2 filesystem is corrupted.
> Resulting in fails. Iam able to find that the JFFS2 garbage collector
> is causing the problem. If mounted as READ only, I dont have an issue,
> but mounting write only is resulting in corrupted filesystem some
> times.
> 
> Unfortunately I need to mount it with read write support.

Please could you let me know what kernel you are using, on what hardware
-- and show me how this corruption manifests itself. If you could send
it just to me and the linux-mtd@lists.infradead.org list, that would
probably be best.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

