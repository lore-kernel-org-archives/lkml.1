Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbXBYAOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbXBYAOx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 19:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933606AbXBYAOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 19:14:53 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38162 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933605AbXBYAOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 19:14:52 -0500
Date: Sat, 24 Feb 2007 16:14:48 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
cc: David Miller <davem@davemloft.net>, kamezawa.hiroyu@jp.fujitsu.com,
       andi@firstfloor.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: SLUB: The unqueued Slab allocator
In-Reply-To: <20070224193322.GA17276@lazybastard.org>
Message-ID: <Pine.LNX.4.64.0702241613520.4891@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702221040140.2011@schroedinger.engr.sgi.com>
 <20070224142835.4c7a3207.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0702232145340.1872@schroedinger.engr.sgi.com>
 <20070223.215439.92580943.davem@davemloft.net>
 <Pine.LNX.4.64.0702240931030.3912@schroedinger.engr.sgi.com>
 <20070224193322.GA17276@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-637110898-1172362488=:4891"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-637110898-1172362488=:4891
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 24 Feb 2007, J=F6rn Engel wrote:

> How much of a gain is the merging anyway?  Once you start having
> explicit whitelists or blacklists of pools that can be merged, one can
> start to wonder if the result is worth the effort.

It eliminates 50% of the slab caches. Thus it reduces the management=20
overhead by half.


---1700579579-637110898-1172362488=:4891--
