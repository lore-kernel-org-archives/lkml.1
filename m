Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbYJ1KJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbYJ1KJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYJ1KJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:09:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37219 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYJ1KJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:09:43 -0400
Date: Tue, 28 Oct 2008 19:09:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "menage@google.com" <menage@google.com>,
       "xemul@openvz.org" <xemul@openvz.org>
Subject: [PATCH 0/4][mmotm] memcg clean up
Message-Id: <20081028190911.6857b0a6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set is easy clean up and fixes to current memory resource controller in mmotm.

Contents are
 [1/4] make cgroup menu as submenu
 [2/4] divide mem_cgroup's charge behavior to charge/commit/cancel
 [3/4] fix gfp_mask of callers of mem_cgroup_charge_xxx
 [4/4] make memcg's page migration handler simple.

pushed out from memcg updates posted at 23/Oct. These are easy part.
all comments are applied (and spell check is done...)

They are against today's mmotm and tested on x86-64.

Thanks,
-Kame

