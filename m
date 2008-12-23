Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbYLWD0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbYLWD0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 22:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYLWD01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 22:26:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64657 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbYLWD00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 22:26:26 -0500
Message-ID: <49505A23.1080304@cn.fujitsu.com>
Date: Tue, 23 Dec 2008 11:25:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Containers <containers@lists.linux-foundation.org>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroups: avoid accessing uninitialized data in failure
 path
References: <4950595C.9070907@cn.fujitsu.com>
In-Reply-To: <4950595C.9070907@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> If cgroup_get_rootdir() failed, free_cg_links() will be called
> in the failure path, but tmp_cg_links hasn't been initialized
> at that time.
> 
> I should be blamed to introduce this bug in 2.6.26 merge window.
> 

Sorry, I mean 2.6.27 merge window.

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
