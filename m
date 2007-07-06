Return-Path: <linux-kernel-owner+w=401wt.eu-S1762707AbXGFHHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707AbXGFHHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758413AbXGFHGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:06:55 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:48773 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759946AbXGFHGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:06:54 -0400
Message-ID: <468DE9A8.8000107@linux.vnet.ibm.com>
Date: Fri, 06 Jul 2007 00:05:12 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Eric W Biederman <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>
Subject: Re: [-mm PATCH 6/8] Memory controller add per container LRU and reclaim
 (v2)
References: <20070706052029.11677.16964.sendpatchset@balbir-laptop> <20070706052212.11677.26502.sendpatchset@balbir-laptop>
In-Reply-To: <20070706052212.11677.26502.sendpatchset@balbir-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> +unsigned long mem_container_isolate_pages(unsigned long nr_to_scan,
> +					struct list_head *dst,
> +					unsigned long *scanned, int order,
> +					int mode, struct zone *z,
> +					struct mem_container *mem_cont,
> +					int active)

[snip]

> +{
> +		/*
> +		 * Check if the meta page went away from under us
> +		 */
> +		if (!list_empty(&mp->list)

There is a small typo here, we need an extra brace at the end
(I should have done a refpatch :( )


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
