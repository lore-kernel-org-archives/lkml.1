Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYLEUnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYLEUnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 15:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYLEUnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 15:43:41 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:49526 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYLEUnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 15:43:41 -0500
Subject: Re: [PATCH] memory hotplug: run lru_add_drain_all() on each cpu
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: gerald.schaefer@de.ibm.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com, npiggin@suse.de
In-Reply-To: <1228482500.8392.15.camel@t60p>
References: <1228339524.6598.11.camel@t60p>
	 <1228342567.13111.11.camel@nimitz>  <1228482500.8392.15.camel@t60p>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 12:43:38 -0800
Message-Id: <1228509818.12681.21.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 14:08 +0100, Gerald Schaefer wrote:
> 
> As explained above, the per-cpu pagevec layout should be independent
> from NUMA or UNEVICTABLE_LRU, so I guess the right thing to do here
> is completely remove the #ifdef as in the patch from Kosaki Motohiro
> (or at least replace it with a CONFIG_SMP as suggested by Kamezawa
> Hiroyuki).

Thanks for looking into it deeper.  That CONFIG_SMP thing really does
look like the right solution.

-- Dave

