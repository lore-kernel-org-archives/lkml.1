Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbXHTSOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbXHTSOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 14:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbXHTSOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 14:14:09 -0400
Received: from mx1.wp.pl ([212.77.101.5]:53195 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbXHTSOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 14:14:08 -0400
Date: Mon, 20 Aug 2007 20:19:13 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Markus Dahms <mad@automagically.de>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: possible endless loop in PROM initialization
Message-Id: <20070820201913.7a3e9009.krzysztof.h1@wp.pl>
In-Reply-To: <20070820105320.GB4911@vimes.madsworld.lan>
References: <20070820075949.GA5927@vimes.madsworld.lan>
	<20070820.010622.41634915.davem@davemloft.net>
	<20070820105320.GB4911@vimes.madsworld.lan>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000                                      
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007 12:53:20 +0200
Markus Dahms <mad@automagically.de> wrote:

> Hello again,

> As I'm not sure anymore whether the device tree (show-devs) or the aliases
> (devalias) are broken on the Classic X (I "upgraded" mine to a Classic by
> changing some NVRAM bytes) this may be a non-issue. But it is still an
> endless loop where it don't has to be.
> 

I understand your problem now. The only rational solution is
to stop building the list in the build_one_prop() if the property 
with already found name is defined.

Changing way the *_nextprop() works seems not a good 
idea to me.

My two cents,
Krzysztof
