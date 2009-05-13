Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbZEMIcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbZEMIcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbZEMIb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:31:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34229 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZEMIb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:31:58 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC] Replace the watermark-related union in struct zone with a watermark[] array V2
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Hansen <dave@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090512141331.GI25923@csn.ul.ie>
References: <1241099300.29485.96.camel@nimitz> <20090512141331.GI25923@csn.ul.ie>
Message-Id: <20090513173138.7237.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 May 2009 17:31:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Changelog since V1
>   o Use N_wmark_pages accessors instead of array accesses
> 
> Patch page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark
> from -mm added a union to struct zone where the watermarks could be accessed
> with either zone->pages_* or a pages_mark array. The concern was that this
> aliasing caused more confusion that it helped.
> 
> This patch replaces the union with a watermark array that is indexed with
> WMARK_* defines accessed via helpers. All call sites that use zone->pages_*
> are updated to use the helpers for accessing the values and the array
> offsets for setting.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

looks good to me :)




