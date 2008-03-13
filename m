Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYCMQrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYCMQrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbYCMQr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:47:26 -0400
Received: from styx.suse.cz ([82.119.242.94]:56995 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756078AbYCMQrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:47:24 -0400
Date: Thu, 13 Mar 2008 17:47:23 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-list@namesys.com, Jan Engelhardt <jengelh@computergmbh.de>,
       Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH 0/4] Automatic quotaon on remount
Message-ID: <20080313164723.GK12523@duck.suse.cz>
References: <20080313125944.GF12523@duck.suse.cz> <20080313163734.GA3980@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313163734.GA3980@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-03-08 12:37:34, Christoph Hellwig wrote:
> On Thu, Mar 13, 2008 at 01:59:44PM +0100, Jan Kara wrote:
> >   Hi,
> > 
> >   the series of patches below implements automatic enabling of quotas on
> > remount read-write when filesystem with quotas enabled has previously been
> > remounted read-only (and thus quotas had to be disabled).
> >   The patches are split logically, but due to interface changes all four
> > patches need to be applied together or ext3, ext4 or reiserfs won't
> > compile.
> > 
> > [PATCH 1/4] quota: Quota core changes for quotaon on remount
> > [PATCH 2/4] ext3: Make ext3 handle quotaon on remount
> > [PATCH 3/4] ext4: Make ext4 handle quotaon on remount
> > [PATCH 4/4] reiserfs: Make reiserfs handle quotaon on remount
> 
> No need to touch jfs?
  No, since JFS doesn't use quota_on callback and doesn't do journaled
quotas which require calling vfs_quota_on/off during journal replay. But
thanks for the suggestion :).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
