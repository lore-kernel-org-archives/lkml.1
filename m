Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYKFPFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYKFPFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYKFPFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:05:40 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:56349 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbYKFPFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:05:39 -0500
Date: Thu, 6 Nov 2008 09:04:54 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, travis@sgi.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch 7/7] cpu alloc: page allocator conversion
In-Reply-To: <20081106115113.0D38.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0811060904030.3595@quilx.com>
References: <20081105231634.133252042@quilx.com> <20081105231650.526116017@quilx.com>
 <20081106115113.0D38.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, KOSAKI Motohiro wrote:

> > -		free_zone_pagesets(cpu);
> > +		process_zones(cpu);
> >  		break;
>
> Why do you drop cpu unplug code?

Because it does not do anything. Percpu areas are traditionally allocated
for each possible cpu not for each online cpu.

