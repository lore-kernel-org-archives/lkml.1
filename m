Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbYIKO3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbYIKO3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYIKO3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:29:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63008 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbYIKO3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:29:30 -0400
Message-ID: <48C92AAA.6030206@cn.fujitsu.com>
Date: Thu, 11 Sep 2008 22:26:50 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH -mm 2/2] cgroup: fold struct cg_cgroup_link into struct
 css_set
References: <48C929DF.3050009@cn.fujitsu.com>
In-Reply-To: <48C929DF.3050009@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry for not send to Andrew Morton and send to Paul Menage tiwce.

add [To: Andrew Morton <akpm@linux-foundation.org>]

	Thanks, Lai

Lai Jiangshan wrote:
> one struct cg_cgroup_link per link is very waste.
> This way need to allocate struct cg_cgroup_link for
> (css_set_count * hierarchy_count) times. And it will bring fragments
> for memory allocation.
> 

