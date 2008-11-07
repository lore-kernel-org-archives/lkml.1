Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbYKGAhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbYKGAhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 19:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYKGAhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 19:37:23 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53286 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbYKGAhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 19:37:21 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch 7/7] cpu alloc: page allocator conversion
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, travis@sgi.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0811060904030.3595@quilx.com>
References: <20081106115113.0D38.KOSAKI.MOTOHIRO@jp.fujitsu.com> <Pine.LNX.4.64.0811060904030.3595@quilx.com>
Message-Id: <20081107093137.F84D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri,  7 Nov 2008 09:37:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 6 Nov 2008, KOSAKI Motohiro wrote:
> 
> > > -		free_zone_pagesets(cpu);
> > > +		process_zones(cpu);
> > >  		break;
> >
> > Why do you drop cpu unplug code?
> 
> Because it does not do anything. Percpu areas are traditionally allocated
> for each possible cpu not for each online cpu.

Yup, Agreed.

However, if cpu-unplug happend, any pages in pcp should flush to buddy (I think).



