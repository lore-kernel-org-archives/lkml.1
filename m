Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbZEFOXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbZEFOXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZEFOXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:23:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41653 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753778AbZEFOXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:23:46 -0400
Date: Wed, 6 May 2009 15:21:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>, Rik van Riel <riel@redhat.com>,
       Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, chrisw@redhat.com, device@lanana.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 2/6] ksm: dont allow overlap memory addresses
 registrations.
Message-ID: <20090506152100.41266e4c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090506140904.GY16078@random.random>
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com>
	<1241475935-21162-2-git-send-email-ieidus@redhat.com>
	<1241475935-21162-3-git-send-email-ieidus@redhat.com>
	<4A00DD4F.8010101@redhat.com>
	<4A015C69.7010600@redhat.com>
	<4A0181EA.3070600@redhat.com>
	<20090506131735.GW16078@random.random>
	<Pine.LNX.4.64.0905061424480.19190@blonde.anvils>
	<20090506140904.GY16078@random.random>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the max number of ksm pages that can be allocated at any given time so
> to avoid OOM conditions, like the swap-compress logic that limits the
> swapdevice size to less than ram.

Are those pages accounted for in the vm_overcommit logic, as if you
allocate a big chunk of memory as KSM will do you need the worst case
vm_overcommit behaviour preserved and that means keeping the stats
correct.

