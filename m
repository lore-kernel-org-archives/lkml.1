Return-Path: <linux-kernel-owner+w=401wt.eu-S1761369AbXGEOec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761369AbXGEOec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757492AbXGEOeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:34:25 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:38664 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbXGEOeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:34:24 -0400
Message-ID: <468D00FF.6070106@linux.vnet.ibm.com>
Date: Thu, 05 Jul 2007 07:32:31 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@openvz.org>
CC: Kirill Korotaev <dev@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>
Subject: Re: [-mm PATCH 0/7] Memory controller introduction
References: <20070704222108.17702.40293.sendpatchset@balbir-laptop> <468CB658.7000204@openvz.org>
In-Reply-To: <468CB658.7000204@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Pavel,

Pavel Emelianov wrote:
> Balbir Singh wrote:
> 
> As far as I remember at OLS we decided to implement per-zone RLU
> lists and reuse the lru lock as well. This will remove all the 
> problems with per-container lists inconsistency.
> 

It's there in the TODO list. It is easy to implement. I can do that
in the next revision. We are re-using the LRU lock, since the
isolate_pages callback is called under the zone's LRU lock.

> Separate limits for RSS and RSS+pagecache are also a must.
> 

I remember that we discussed having one limit, but we can come up
with a configuration parameter to do it. I'll do that in the
next release.

> BTW, if you send smb. else's patches you may include a 'From: xxx'
> line into the letter to address the original author.
> 

I'll do that for the res_counters_infra patch. Although I had used
res_counter, the hooks in mm_struct earlier (http://lkml.org/lkml/2007/2/19/12).

A lot of the code for the reclaim logic and the meta_page is yours.
Please do identify patches where you would like to see your
signed-off-by and where you think the entire patch is completely
yours.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
