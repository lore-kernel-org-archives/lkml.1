Return-Path: <linux-kernel-owner+w=401wt.eu-S1762183AbYCZS5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762183AbYCZS5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYCZS46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:56:58 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:59268 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086AbYCZS46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:56:58 -0400
Message-ID: <47EA9BB0.3030202@linux.vnet.ibm.com>
Date: Thu, 27 Mar 2008 00:23:36 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Balaji Rao <balajirrao@gmail.com>, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, balbir@in.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: [RFC][-mm] [2/2] Simple stats for memory resource controller
References: <200803262348.59785.balajirrao@gmail.com> <6599ad830803261152j1973e3c8oa82181a830f89260@mail.gmail.com>
In-Reply-To: <6599ad830803261152j1973e3c8oa82181a830f89260@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Wed, Mar 26, 2008 at 11:18 AM, Balaji Rao <balajirrao@gmail.com> wrote:
>>         [MEM_CGROUP_STAT_RSS] = { "rss", PAGE_SIZE, },
>>  +       [MEM_CGROUP_STAT_PGIN_COUNT] = {"page_in_count", 1, },
>>  +       [MEM_CGROUP_STAT_PGOUT_COUNT] = {"page_out_count", 1, },
>>   };
>>
> 
> Should these be called "pgpgin" and "pgpgout" for consistency with /proc/vmstat?
> 
> Paul

Yes, that is a good name. We also want to instantaneous metrics like
page_in_count per second and page_out_count per second to help the administrator
monitor what is going on within the tasks in the cgroup w.r.t. memory.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
