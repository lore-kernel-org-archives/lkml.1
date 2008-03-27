Return-Path: <linux-kernel-owner+w=401wt.eu-S1761326AbYC0WOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326AbYC0WOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 18:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758918AbYC0WOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 18:14:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40346 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537AbYC0WOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 18:14:05 -0400
Date: Thu, 27 Mar 2008 22:13:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/7] vfs: mountinfo: add mount ID
Message-ID: <20080327221358.GY10722@ZenIV.linux.org.uk>
References: <20080327120619.031944658@szeredi.hu> <20080327122355.594127612@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327122355.594127612@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 01:06:22PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add a unique ID to each vfsmount using the IDR infrastructure.  The
> identifiers are reused after the vfsmount is freed.

Er...  That would need shifting allocation to attach_recursive_mnt()
and copy_tree()...

Anyway, nevermind that for now; I'll pick the variant with spinlock
from the previous patchset.
