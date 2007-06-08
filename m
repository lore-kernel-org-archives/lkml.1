Return-Path: <linux-kernel-owner+w=401wt.eu-S967126AbXFHIUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967126AbXFHIUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932131AbXFHIUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 04:20:06 -0400
Received: from THUNK.ORG ([69.25.196.29]:44645 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763659AbXFHIUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 04:20:03 -0400
Date: Fri, 8 Jun 2007 04:19:44 -0400
From: Theodore Tso <tytso@mit.edu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 34/54] Fix roundup_pow_of_two(1)
Message-ID: <20070608081944.GA12687@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
	stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Rolf Eike Beer <eike-kernel@sf-tec.de>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <20070608072127.352723000@sous-sol.org> <20070608072220.006310000@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608072220.006310000@sous-sol.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 12:22:01AM -0700, Chris Wright wrote:
> -stable review patch.  If anyone has any objections, please let us know.
> ---------------------
> 
> From: Rolf Eike Beer <eike-kernel@sf-tec.de>
> 
> Fix roundup_pow_of_two(1)
> 
> 1 is a power of two, therefore roundup_pow_of_two(1) should return 1. It does
> in case the argument is a variable but in case it's a constant it behaves
> wrong and returns 0. Probably nobody ever did it so this was never noticed.

If this doesn't fix a user-visiable bug, should we be including it in
the stable patch series?  (Assuming that it doesn't, I wouldn't, but I
tend to be more conservative about what I would include in a stable
production release.)

Regards,

						- Ted
