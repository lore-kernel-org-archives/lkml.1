Return-Path: <linux-kernel-owner+w=401wt.eu-S934589AbXJLXRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934589AbXJLXRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762015AbXJLW5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:57:07 -0400
Received: from [212.12.190.36] ([212.12.190.36]:48177 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761603AbXJLW5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:57:01 -0400
From: Al Boldi <a1426z@gawab.com>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFD] iptables:  mangle table obsoletes filter table
Date: Sat, 13 Oct 2007 01:56:58 +0300
User-Agent: KMail/1.5
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200710120031.42805.a1426z@gawab.com> <200710121618.51046.a1426z@gawab.com> <470F7555.4090500@trash.net>
In-Reply-To: <470F7555.4090500@trash.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710130156.58279.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Al Boldi wrote:
> > But can you see how forcing people into splitting
> > their rules across tables adds complexity.  And without ipt_REJECT
> > patch, they can't even use REJECT in prerouting, which forces them to do
> > some strange hacks.
> >
> > IMHO, we should make things as easily configurable as possible, and as
> > things stand right now, the filter-table is completely useless for 99%
> > of use-cases.
>
> Sure, as I said, patches to remove the arbitary restrictions to
> tables are welcome, but please do this for all targets and
> matches which allow this, not only REJECT. And if you include a
> seperate (tested) patch for the IPv4 and IPv6 REJECT targets
> I'll consider it as well.

Sounds fair.  All we need now is for someone to kindly submit these rather 
straight forward patches.


Thanks!

--
Al

