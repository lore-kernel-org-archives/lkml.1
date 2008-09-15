Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYIOCD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYIOCD5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 22:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbYIOCDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 22:03:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54033 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbYIOCDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 22:03:47 -0400
Message-ID: <48CDC1FA.50802@cn.fujitsu.com>
Date: Mon, 15 Sep 2008 10:01:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH -mm 2/2] cgroup: fold struct cg_cgroup_link into struct
 css_set
References: <48C929DF.3050009@cn.fujitsu.com> <6599ad830809111050h27d22369m8fc4faa47920f784@mail.gmail.com>
In-Reply-To: <6599ad830809111050h27d22369m8fc4faa47920f784@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:

> Yes, the code is definitely simpler after your patch. It's pretty much
> how it was *before* I introduced the cg_cgroup_link structures to
> allow an arbitrary number of hierarchies without bloating the css_set
> structure. I'm not convinced that we want to go back to the original
> way.
> 

I didn't know this history. Thank you.

Lai

