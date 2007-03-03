Return-Path: <linux-kernel-owner+w=401wt.eu-S932331AbXCCUk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbXCCUk6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 15:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932304AbXCCUk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 15:40:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331AbXCCUk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 15:40:57 -0500
Message-ID: <45E9DD4A.2060806@redhat.com>
Date: Sat, 03 Mar 2007 15:40:42 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
In-Reply-To: <20070303122935.f1ab0067.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> It is to address the "waah, backups fill my memory with pagecache" and the
> "waah, updatedb swapped everything out" and the "waah, copying a DVD
> gobbled all my memory" problems.

By removing pressure from the page cache, you'll only allow updatedb
to grow the inode and dentry caches larger than before.

I am sick and tired of the "this is hard, let userspace do it" attitude.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
