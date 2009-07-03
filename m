Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbZGCBOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbZGCBOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbZGCBOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:14:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51278 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbZGCBOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:14:07 -0400
Message-ID: <4A4D5B98.6000509@cn.fujitsu.com>
Date: Fri, 03 Jul 2009 09:15:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: lizf@cn.fujitzu.com, serue@us.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, bblum@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] CGroups: cgroup member list enhancement/fix
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> The following series (written by Ben Blum) adds a "cgroup.procs" file

This is rather useful. :)

> to each cgroup that reports unique tgids rather than pids, and fixes a
> pid namespace bug in the existing "tasks" file that could cause
> readers in different namespaces to interfere with one another.
> 
> The patches as a pair provide similar functionality to Li Zefan's
> patch posted yesterday, with the addition on the "cgroup.procs" file;
> if it's decided that Li's patch needs to be fast-tracked to 2.6.31,
> then these patches can be rebased as a small extension of Li's patch;
> if Li'z patch doesn't need to go to 2.6.31 then it makes more sense to
> take this pair since they provide more overall functionality.
> 

I'd prefer fixing it for 2.6.31. There is no reason we don't fix it
earlier than later. Base a fix on top of a new feature is no good,
and it makes backporting the fix harder if someone wants to do this.

