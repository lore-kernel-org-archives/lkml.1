Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbZFWWQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbZFWWQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZFWWPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:15:53 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51513 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbZFWWPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:15:53 -0400
Subject: Re: [PATCH] Hugepages should be accounted as unevictable pages.
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: akataria@vmware.com
Cc: Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Mel Gorman <mel@csn.ul.ie>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <1245793331.24110.33.camel@alok-dev1>
References: <20090623093459.2204.A69D9226@jp.fujitsu.com>
	 <1245732411.18339.6.camel@alok-dev1>
	 <20090623135017.220D.A69D9226@jp.fujitsu.com>
	 <20090623141147.8f2cef18.kamezawa.hiroyu@jp.fujitsu.com>
	 <1245736441.18339.21.camel@alok-dev1>  <4A41481D.1060607@redhat.com>
	 <1245793331.24110.33.camel@alok-dev1>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 15:15:52 -0700
Message-Id: <1245795352.17685.31312.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 14:42 -0700, Alok Kataria wrote:
> One thing that i forgot to mention earlier is that, I just need a way to
> provide a hint about the total locked memory  on the system and it
> doesn't need to be the exact number at that point in time.
> 
> Lee, due to this reason lazy culling of unevictable pages is fine too. 
> 
> Hugepages, similar to mlocked pages, are special because the user could
> specify how much memory it wants to reserve for this purpose. So that
> needs to be taken into consideration i.e it cannot be calculated in some
> way. 

Could you just teach the thing to which you are hinting that it also
needs to go look in sysfs for huge page counts?  Or, is there a
requirement that it come out of a single meminfo field?

-- Dave

