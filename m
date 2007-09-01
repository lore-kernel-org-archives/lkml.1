Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbXIAJMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbXIAJMj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 05:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbXIAJMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 05:12:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbXIAJM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 05:12:29 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: nmi_watchdog=2 regression in 2.6.21
Date: Sat, 1 Sep 2007 11:12:24 +0200
User-Agent: KMail/1.9.6
Cc: =?utf-8?q?Bj=C3=B6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <20070828170556.GI1645@frankl.hpl.hp.com> <20070831180644.GA24174@atjola.homenet> <1188606286.26038.117.camel@dhcp193.mvista.com>
In-Reply-To: <1188606286.26038.117.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709011112.24320.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> If you look at the LOC values you'll notice a lot of time has passed,
> with only one NMI and on only one cpu ..
> 
> It's possible this is something else completely tho ..

It only ticks when the CPU is not idle. If you want to see the "operating 
frequency" run a main(){for(;;;);} for each core. 

-Andi
