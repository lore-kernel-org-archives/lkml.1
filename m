Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYJGVTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYJGVTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbYJGVTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:19:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430AbYJGVTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:19:14 -0400
Date: Tue, 7 Oct 2008 14:19:12 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
       tao.ma@oracle.com
Subject: Re: [PATCH 11/39] ocfs2: Add extent tree operation for xattr value btrees
Message-ID: <20081007211912.GF26373@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com> <1222293680-15451-12-git-send-email-mfasheh@suse.com> <20081001231205.1652365b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001231205.1652365b.akpm@linux-foundation.org>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 11:12:05PM -0700, Andrew Morton wrote:
> > On Wed, 24 Sep 2008 15:00:52 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> > +	if (eb_bh)
> > +		brelse(eb_bh);
> 
> brelse(0) is legal.  Please do an fs-wide review for this.

Ok, I'll queue that up. I'll watch to make sure that new patches from here
on won't do this.


> It shouldn't affect code generation because brelse() is inlined.

Fair enough, thanks.
	--Mark


--
Mark Fasheh
