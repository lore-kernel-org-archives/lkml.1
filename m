Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbXFAGug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbXFAGug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 02:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbXFAGu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 02:50:29 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:61785 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbXFAGu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 02:50:28 -0400
Message-ID: <465FC19B.8090905@linux.vnet.ibm.com>
Date: Fri, 01 Jun 2007 12:20:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelianov <xemul@openvz.org>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 7/8] Scanner changes needed to implement per-container
 scanner
References: <465D9739.8070209@openvz.org> <465D9ABD.7050506@openvz.org> <20070530144647.0ace89f3.akpm@linux-foundation.org>
In-Reply-To: <20070530144647.0ace89f3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
>> +		nr_reclaimed += shrink_zones(priority, zones, sc);
>> +		if (sc->cnt == NULL)
>> +			shrink_slab(sc->nr_scanned, gfp_mask, lru_pages);
> 
> We don't we shrink slab if called to shrink a container.
> 
> This is a fundamental design decision, and a design shortcoming.  A full
> discussion of this is absolutely appropriate to the patch changelog. 
> Please don't just hide stuff like this in the patch and leave people
> wondering, or ignorant.

Yes, we don't because we do not account for slab usage right now. We account
only for memory allocated to user space. A good fat comment will help here.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
