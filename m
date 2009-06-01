Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbZFAWyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbZFAWyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 18:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbZFAWyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 18:54:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:45873 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174AbZFAWyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 18:54:38 -0400
Subject: Re: [regression, bisected] adb trackpad disappears after suspend
 to ram
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jan Scholz <scholz@fias.uni-frankfurt.de>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200906020042.37036.rjw@sisk.pl>
References: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de>
	 <200906011836.15507.rjw@sisk.pl>
	 <877hzv8txp.fsf@scholz.fias.uni-frankfurt.de>
	 <200906020042.37036.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 08:52:23 +1000
Message-Id: <1243896743.591.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Tried this, but it does not help.
> > 
> > What I haven't noticed before is, that even if the trackpad already
> > disappeared, an additional suspend-resume cycle from the console brought
> > it back to life every time. Sometimes this worked from within X as well,
> > just not with such a high probability as from the console.
> > However, this is independent from 'sleepy_trackpad = 1'. 
> 
> OK, thanks for testing.  I think I know what to do, but I need some time to
> prepare a patch.

I wonder if the trakpad is timing out at some stage, we don't drain it
properly before suspend or something like that. Those ADB things are
a bit strange.

Ben.


