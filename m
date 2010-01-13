Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372Ab0AMTpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab0AMTpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 14:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763Ab0AMTpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 14:45:04 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41999 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab0AMTpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 14:45:01 -0500
Date: Wed, 13 Jan 2010 19:44:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ecryptfs: Fix refcnt leak on ecryptfs_follow_link()
 error path
Message-ID: <20100113194458.GB4673@ZenIV.linux.org.uk>
References: <87my0kjxpd.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87my0kjxpd.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 03:36:14AM +0900, OGAWA Hirofumi wrote:
> 
> If ->follow_link handler return the error, it should decrement
> nd->path refcnt. But, ecryptfs_follow_link() doesn't decrement.
> 
> This patch fix it by using usual nd_set_link() style error handling,
> instead of playing with nd->path.

Applied.
