Return-Path: <linux-kernel-owner+w=401wt.eu-S1763151AbZDALjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763151AbZDALjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbZDALjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:39:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59925 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbZDALji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:39:38 -0400
Date: Wed, 1 Apr 2009 12:39:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
       adilger@sun.com, linux-ext4@vger.kernel.org, alex@clusterfs.com,
       aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [PATCH] Remove two unneeded exports and make two symbols
	static in fs/mpage.c
Message-ID: <20090401113934.GB28946@ZenIV.linux.org.uk>
References: <1238449280-10318-1-git-send-email-dmitri.vorobiev@movial.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238449280-10318-1-git-send-email-dmitri.vorobiev@movial.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 12:41:20AM +0300, Dmitri Vorobiev wrote:
> Commit 29a814d2ee0e43c2980f33f91c1311ec06c0aa35 (vfs: add hooks for
> ext4's delayed allocation support) exported the following functions
> 
> mpage_bio_submit()
> __mpage_writepage()
> 
> for the benefit of ext4's delayed allocation support. Since commit
> a1d6cc563bfdf1bf2829d3e6ce4d8b774251796b (ext4: Rework the
> ext4_da_writepages() function), these functions are not used by the
> ext4 driver anymore. However, the now unnecessary exports still
> remain, and this patch removes those. Moreover, these two functions
> can become static again.
> 
> The issue was spotted by namespacecheck.
> 
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>

Applied.
