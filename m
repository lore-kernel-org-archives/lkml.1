Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbZHTCjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbZHTCjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZHTCjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:39:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60127 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbZHTCjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:39:36 -0400
Message-ID: <4A8CB717.7000804@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 10:38:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 5/8] Changes css_set freeing mechanism to be under RCU
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com> <20090818235832.22531.96610.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090818235832.22531.96610.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07:58, Paul Menage wrote:
> From: Ben Blum <bblum@google.com>
> 
> 
> Changes css_set freeing mechanism to be under RCU
> 
> This is a prepatch for making the procs file writable. In order to free the
> old css_sets for each task to be moved as they're being moved, the freeing
> mechanism must be RCU-protected, or else we would have to have a call to
> synchronize_rcu() for each task before freeing its old css_set.
> 
> Signed-off-by: Ben Blum <bblum@google.com>
> Signed-off-by: Paul Menage <menage@google.com>
> 

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

