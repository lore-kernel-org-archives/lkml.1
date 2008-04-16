Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbYDPVZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbYDPVZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYDPVZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:25:27 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59716 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbYDPVZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:25:26 -0400
Message-ID: <48066EBE.3040608@us.ibm.com>
Date: Wed, 16 Apr 2008 14:25:18 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20080131)
MIME-Version: 1.0
To: prasad@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       hunt@redhat.com
Subject: Re: [RFC Patch 1/1] debugfs_printk and debugfs_dump interface
References: <20080415111459.GB5295@in.ibm.com> <20080415112603.GA5770@in.ibm.com>
In-Reply-To: <20080415112603.GA5770@in.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K. Prasad wrote:
>

> +
> +struct debugfs_printk_data {
> +	char *parent_dir;
> +	char *dir;
> +	int exists;
> +	int buf_size;
> +	int sub_buf_size;
> +};

How about adding a "flags" field here to hold the trace channel flags. 
Pass the flags through to trace_setup().  This way the caller can 
control the trace options.

Add a description of debugfs_printk() and debugfs_dump() to 
Documentation/trace.txt.
