Return-Path: <linux-kernel-owner+w=401wt.eu-S933241AbXH3TAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbXH3TAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 15:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932599AbXH3TAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 15:00:45 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:43163 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbXH3TAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 15:00:44 -0400
Message-ID: <46D713D5.6030709@linux.vnet.ibm.com>
Date: Fri, 31 Aug 2007 00:30:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [-mm PATCH]  Memory controller improve user interface (v2)
References: <20070830185246.3170.74806.sendpatchset@balbir-laptop>
In-Reply-To: <20070830185246.3170.74806.sendpatchset@balbir-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Change the interface to use kilobytes instead of pages. Page sizes can vary
> across platforms and configurations. A new strategy routine has been added
> to the resource counters infrastructure to format the data as desired.
> 

Typo, the description should be

Changelog for version 2

1. Back end tracking is done in bytes, round up values of the limit if the
   specified value is not a multiple of page size. Display memory.usage
   and memory.limit in bytes (Dave Hansen, Paul Menage)

Change the interface to use bytes instead of pages. Page sizes can vary
across platforms and configurations. A new strategy routine has been added
to the resource counters infrastructure to format the data as desired.

Suggested by David Rientjes, Andrew Morton and Herbert Poetzl

Tested on a UML setup with the config for memory control enabled.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
