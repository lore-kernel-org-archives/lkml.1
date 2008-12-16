Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbYLPQih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbYLPQih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbYLPQiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:38:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45368 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648AbYLPQiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:38:10 -0500
Date: Tue, 16 Dec 2008 16:38:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vfs: introduce helper function to safely NUL-terminate
	symlinks
Message-ID: <20081216163808.GU28946@ZenIV.linux.org.uk>
References: <1229442720-31056-1-git-send-email-duaneg@dghda.com> <1229442720-31056-2-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229442720-31056-2-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 03:51:53PM +0000, Duane Griffin wrote:
> A number of filesystems were potentially triggering kernel bugs due to
> corrupted symlink names on disk. This helper helps safely terminate the
> names.

s/unsigned/size_t/g and into the queue that goes...
