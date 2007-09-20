Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbXITFtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbXITFtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbXITFtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:49:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38121 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694AbXITFtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:49:14 -0400
Date: Wed, 19 Sep 2007 22:48:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 6/11] eCryptfs: Update metadata read/write functions
Message-Id: <20070919224817.78d5c5a4.akpm@linux-foundation.org>
In-Reply-To: <20070917214844.GN13679@halcrow.austin.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com>
	<20070917214844.GN13679@halcrow.austin.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 16:48:44 -0500 Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> +		if ((rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode,

checkpatch missed the assignment-in-an-if here.
