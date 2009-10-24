Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZJXSai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZJXSai (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 14:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZJXSai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 14:30:38 -0400
Received: from mail2.shareable.org ([80.68.89.115]:35494 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZJXSah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 14:30:37 -0400
Date: Sat, 24 Oct 2009 19:30:39 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>, ocfs2-devel@oss.oracle.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 1/2] fiemap: Add new extent flag FIEMAP_EXTENT_SHARED
Message-ID: <20091024183039.GB30762@shareable.org>
References: <1256173509-2831-1-git-send-email-sunil.mushran@oracle.com> <1256173509-2831-2-git-send-email-sunil.mushran@oracle.com> <20091023180034.GA11402@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023180034.GA11402@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Fasheh wrote:
> On Wed, Oct 21, 2009 at 06:05:08PM -0700, Sunil Mushran wrote:
> > Patch adds flag FIEMAP_EXTENT_SHARED to denote extents that are
> > shared with other inodes.
> 
> This looks pretty sane to me. Thanks Sunil.

It might be better to have a flag FIEMAP_EXTENT_NOT_SHARED.

Apps which need to know the data is not shared can't safely check
!(flags & FIEMAP_EXTENT_SHARED) because of old kernels which don't set
the flag.

-- Jamie
