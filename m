Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbXKSXNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbXKSXNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 18:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbXKSXMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 18:12:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48568 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbXKSXMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 18:12:45 -0500
Date: Mon, 19 Nov 2007 15:02:33 -0800
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, jeremy@goop.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Michael Krufky <mkrufky@linuxtv.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 07/26] fix the softlockup watchdog to actually
	work
Message-ID: <20071119230233.GA25140@kroah.com>
References: <20071119181438.617190424@mini.kroah.org> <20071119181846.GH15425@kroah.com> <20071119190242.GB12650@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119190242.GB12650@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 08:02:42PM +0100, Ingo Molnar wrote:
> 
> * Greg Kroah-Hartman <gregkh@suse.de> wrote:
> 
> > 2.6.22-stable review patch.  If anyone has any objections, please let 
> > us know.
> 
> we shouldnt do this for 2.6.22 - it has no proper cpu_clock() facility 
> like .23 or .24. So lets leave this alone.

Ok, I've now dropped it, thanks for letting us know.

greg k-h
