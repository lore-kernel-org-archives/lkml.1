Return-Path: <linux-kernel-owner+w=401wt.eu-S1764853AbYDVPCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764853AbYDVPCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYDVPBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:01:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25610 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbYDVPBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:01:53 -0400
Message-ID: <480DFBED.8020304@oracle.com>
Date: Tue, 22 Apr 2008 07:53:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: prasad@linux.vnet.ibm.com
CC: David Wilder <dwilder@us.ibm.com>, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, hunt@redhat.com, michaele@au1.ibm.com,
       dave@linux.vnet.ibm.com
Subject: Re: [RFC Patch 1/1] debugfs_printk and debugfs_dump interface
References: <20080415111459.GB5295@in.ibm.com> <20080415112603.GA5770@in.ibm.com> <48066EBE.3040608@us.ibm.com> <20080421124329.GA14118@in.ibm.com> <20080421101403.cecf4d7b.randy.dunlap@oracle.com> <20080422052222.GA6623@in.ibm.com>
In-Reply-To: <20080422052222.GA6623@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K. Prasad wrote:

> This patch introduces two new interfaces called debugfs_printk and 
> debugfs_dump which can be used to print to the debugfs mount directly.
> It uses the 'trace' infrastructure underneath and is a patch over it.
> A sample file is also created to demonstrate its ease of use.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  Documentation/trace.txt        |   21 ++++
>  include/linux/trace.h          |   55 +++++++++++
>  lib/trace.c                    |  193 +++++++++++++++++++++++++++++++++++++++--
>  samples/trace/Makefile         |    2 
>  samples/trace/fork_new_trace.c |   97 ++++++++++++++++++++
>  5 files changed, 362 insertions(+), 6 deletions(-)

> +
> +/**
> + * debugfs_printk - Output binary into debugfs mount 'directly' using 'trace'

Oops. This is the debugfs_dump() function.

Otherwise it looks good.  Thanks.

> + * @dpk: Structure containing info such as parent_dir and directory
> + * @output: Data that needs to be output
> + * @output_len: Length of the output data
> + */
> +int debugfs_dump(struct debugfs_printk_data *dpk, const void *output,
> +							const int output_len)
> +{


-- 
~Randy
