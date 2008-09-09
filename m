Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbYIIQ04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbYIIQ04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbYIIQ0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:26:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34326 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYIIQ0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:26:44 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <11118085.1220977593430.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 10 Sep 2008 01:26:33 +0900 (JST)
To: righi.andrea@gmail.com
Subject: Re: [RFC] [PATCH -mm] cgroup: limit the amount of dirty file pages
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Carl Henrik Lunde <chlunde@ping.uio.no>,
       Divyesh Shah <dpshah@google.com>, Naveen Gupta <ngupta@google.com>,
       Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Marco Innocenti <m.innocenti@cineca.it>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Vivek Goyal <vgoyal@redhat.com>,
       Matt Heaton <matt@bluehost.com>, David Radford <dradford@bluehost.com>,
       containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
In-Reply-To: <48C6987D.2050905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <48C6987D.2050905@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>This is a totally experimental patch against 2.6.27-rc5-mm1.
>
>It allows to control how much dirty file pages a cgroup can have at any
>given time. This feature is supposed to be strictly connected to a
>generic cgroup IO controller (see below).
>
>Interface: a new entry "filedirty" is added to the file memory.stat,
>reporting the number of dirty file pages (in pages), and a new file
>memory.file_dirty_limit_in_pages is added in the cgroup filesystem to
>show/set the current limit.
>
Before staring patch review, why not dirty_ratio per memcg ?
Is there difficult implementation issue ?

Thanks,
-Kame
