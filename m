Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbYCMQiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbYCMQiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYCMQiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:38:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34119 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYCMQiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:38:13 -0400
Date: Thu, 13 Mar 2008 12:37:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-list@namesys.com, Jan Engelhardt <jengelh@computergmbh.de>,
       Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH 0/4] Automatic quotaon on remount
Message-ID: <20080313163734.GA3980@infradead.org>
References: <20080313125944.GF12523@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313125944.GF12523@duck.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 01:59:44PM +0100, Jan Kara wrote:
>   Hi,
> 
>   the series of patches below implements automatic enabling of quotas on
> remount read-write when filesystem with quotas enabled has previously been
> remounted read-only (and thus quotas had to be disabled).
>   The patches are split logically, but due to interface changes all four
> patches need to be applied together or ext3, ext4 or reiserfs won't
> compile.
> 
> [PATCH 1/4] quota: Quota core changes for quotaon on remount
> [PATCH 2/4] ext3: Make ext3 handle quotaon on remount
> [PATCH 3/4] ext4: Make ext4 handle quotaon on remount
> [PATCH 4/4] reiserfs: Make reiserfs handle quotaon on remount

No need to touch jfs?

