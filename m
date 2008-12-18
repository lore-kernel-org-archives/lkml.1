Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752135AbYLRIzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbYLRIzW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 03:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYLRIzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 03:55:06 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41380 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYLRIzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 03:55:05 -0500
Date: Thu, 18 Dec 2008 17:54:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "menage@google.com" <menage@google.com>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: [PATCH 0/2] memcg: update for fix and cleanup.
Message-Id: <20081218175403.40ad184a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage's css_tryget() is now in -mm queue and it's useful to
make memcg sane. These 2 patches are updates for memcg sanity.

[1/2] memcg fix double free error and refcnt management of memcg.
[2/2] memcg use css_tryget() and remove private obsolete flag.


-Kame

