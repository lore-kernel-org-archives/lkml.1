Return-Path: <linux-kernel-owner+w=401wt.eu-S934391AbZLFXAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391AbZLFXAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934384AbZLFXAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:00:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57396 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934383AbZLFXAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:00:11 -0500
Date: Mon, 7 Dec 2009 00:00:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Alex Chiang <achiang@hp.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Li, Haicheng" <haicheng.li@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC] print symbolic page flag names in bad_page()
Message-ID: <20091206230016.GA18989@one.firstfloor.org>
References: <20091204212606.29258.98531.stgit@bob.kio> <20091206034636.GA7109@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206034636.GA7109@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So how about this patch?

I like it. Decoding the flags by hand is always a very unpleasant experience.
Bonus: dump_page can be called from kgdb too.

-Andi


