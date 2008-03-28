Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbYC1CJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbYC1CJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbYC1CJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:09:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60207 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbYC1CJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:09:16 -0400
Date: Fri, 28 Mar 2008 02:08:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/7] vfs: mountinfo: allow using process root
Message-ID: <20080328020853.GB10722@ZenIV.linux.org.uk>
References: <20080327120619.031944658@szeredi.hu> <20080327122357.850000253@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327122357.850000253@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 01:06:24PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Allow /proc/<pid>/mountinfo to use the root of <pid> to calculate
> mountpoints.
> 
>  - move definition of 'struct proc_mounts' to <linux/mnt_namespace.h>
>  - add the process's namespace and root to this structure
>  - pass a pointer to 'struct proc_mounts' into seq_operations

NB: we might want to collect that stuff in one place.  Sharing details
between proc/base and namespace is not nice and it just got more hairy.
