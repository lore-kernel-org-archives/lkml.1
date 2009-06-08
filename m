Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbZFHOnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbZFHOnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZFHOnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:43:09 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:45425 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753438AbZFHOnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:43:08 -0400
Date: Mon, 8 Jun 2009 10:42:38 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <20090608141212.GE15070@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0906081041310.21954@gentwo.org>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net> <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com> <4A2BCC6F.8090004@redhat.com> <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
 <20090608101739.GA15377@csn.ul.ie> <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com> <20090608110303.GD15377@csn.ul.ie> <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI> <20090608141212.GE15070@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Mel Gorman wrote:

> In addition, include how many objects there are per-slab and include what
> the order is being passed to the page allocator when allocating new slabs.
> Would that be enough to determine if fallback-to-smaller orders occured?

There is a per slab counter ORDER_FALLBACK that is increased for
allocations that required fallback.
