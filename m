Return-Path: <linux-kernel-owner+w=401wt.eu-S1161814AbXDZJrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161814AbXDZJrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161818AbXDZJrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:47:49 -0400
Received: from mx1.suse.de ([195.135.220.2]:49155 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161814AbXDZJrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:47:48 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] change global zonelist order on NUMA v2
Date: Thu, 26 Apr 2007 11:47:44 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
       AKPM <akpm@linux-foundation.org>, Christoph Lameter <clameter@sgi.com>
References: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704261147.44413.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007 11:34:17 KAMEZAWA Hiroyuki wrote:
> 
> Changelog from V1 -> V2
> - sysctl name is changed to be relaxed_zone_order
> - NORMAL->NORMAL->....->DMA->DMA->DMA order (new ordering) is now default.
>   NORMAL->DMA->NORMAL->DMA order (old ordering) is optional.
> - addes boot opttion to set relaxed_zone_order. ia64 is supported now.
> - Added documentation
> 
> patch is against 2.6.21-rc7-mm2. tested on ia64 NUMA box. works well.

IMHO the change should be default (without any options) unless someone
can come up with a good reason why not. On x86-64 it should be definitely
default.

If there is a good reason on some architecture or machine a user option is also not a 
good idea, but instead it should be set automatically by that architecture or machine
on boot.

-Andi

