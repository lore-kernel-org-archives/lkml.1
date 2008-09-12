Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYILXNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYILXNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 19:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbYILXNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 19:13:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754836AbYILXNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 19:13:06 -0400
Date: Fri, 12 Sep 2008 16:10:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: righi.andrea@gmail.com
Cc: balbir@linux.vnet.ibm.com, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, dave@linux.vnet.ibm.com,
       chlunde@ping.uio.no, dpshah@google.com, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, agk@sourceware.org, m.innocenti@cineca.it,
       s-uchida@ap.jp.nec.com, ryov@valinux.co.jp, matt@bluehost.com,
       dradford@bluehost.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, mrubin@google.com
Subject: Re: [RFC] [PATCH -mm 0/2] memcg: per cgroup dirty_ratio
Message-Id: <20080912161050.5b6b4065.akpm@linux-foundation.org>
In-Reply-To: <48CAF583.8060406@gmail.com>
References: <1221232192-13553-1-git-send-email-righi.andrea@gmail.com>
	<20080912131816.e0cfac7a.akpm@linux-foundation.org>
	<48CAF583.8060406@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep 2008 01:04:35 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:

> BTW why not use a simple dirty-ratio-in-bytes?

s/ratio/amount/  ;)

No particular reason - I haven't really thought about it frankly.

A "ratio" might make more sense in a containerised setup, particularly
if the container can be resized on the fly.
