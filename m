Return-Path: <linux-kernel-owner+w=401wt.eu-S1752529AbYCLEky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbYCLEky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 00:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYCLEkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 00:40:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbYCLEkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 00:40:45 -0400
Date: Tue, 11 Mar 2008 21:40:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add the max_usage member on the res_counter
Message-Id: <20080311214034.d2cae354.akpm@linux-foundation.org>
In-Reply-To: <47D69D72.5040304@openvz.org>
References: <47D69D72.5040304@openvz.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 17:55:46 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:

> This field is the maximal value of the usage one since the counter
> creation (or since the latest reset).
> 
> To reset this to the usage value simply write anything to the
> appropriate cgroup file.

What is the justification for making this change?  Why do we need it? 
Please provide this information for all patches where it is not obvious.

>  	{
> +		.name = "max_usage_in_bytes",
> +		.private = RES_MAX_USAGE,
> +		.write = mem_cgroup_max_reset,
> +		.read_u64 = mem_cgroup_read,
> +	},

Documentation/controllers/memory.txt needs updating.
