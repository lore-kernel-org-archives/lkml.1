Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbXLVWYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbXLVWYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 17:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbXLVWYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 17:24:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53311 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbXLVWYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 17:24:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Subject: Re: [2.6.24-rc6] pdflush still stuck in D state regression
Date: Sat, 22 Dec 2007 23:43:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
References: <200712221404.24117.tvrtko@ursulin.net>
In-Reply-To: <200712221404.24117.tvrtko@ursulin.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712222343.35670.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 22 of December 2007, Tvrtko A. Ursulin wrote:
> 
> Hi,

Hi,

> As it was in this bug report: http://bugzilla.kernel.org/show_bug.cgi?id=9441

I have reopened http://bugzilla.kernel.org/show_bug.cgi?id=9291 .  Please
update add the new information in there.
 
> I am still not sure it is a duplicate because it has nothing to do with reiserfs on 
> my systems. Here is the latest trace:
> 
> pdflush       S 00000000     0   139      2
>        00000000 00000046 eba01fc4 00000000 b0155a80 00000000 b0155b2c eb820000 
>        eaab6fc0 00000000 b02aa388 b034d9b0 b034d9b0 fffb6e4a fffffffc b012f0d2 
>        b012f090 00000000 00000000 b0104b6f eb817f44 00000000 00000000 00000000 
> Call Trace:
>  [<b0155a80>] pdflush+0x0/0x210
>  [<b0155b2c>] pdflush+0xac/0x210
>  [<b02aa388>] schedule+0x168/0x2e0
>  [<b012f0d2>] kthread+0x42/0x70
>  [<b012f090>] kthread+0x0/0x70
>  [<b0104b6f>] kernel_thread_helper+0x7/0x18
>  =======================
> pdflush       D 00140f4c     0   140      2
>        b02af660 00000046 eba03f10 00140f4c 0000444d 000f22fd b02aa9a9 eb5e092c 
>        eba03f74 b03cbfe8 b03cbfe8 00140f4c b0124700 eaab7500 b03cbd80 b02aa9a4 
>        6c666470 00687375 00000000 00000000 0000008c 00000064 b034da20 b02aa20b 
> Call Trace:
>  [<b02aa9a9>] schedule_timeout+0x49/0xc0
>  [<b0124700>] process_timeout+0x0/0x10
>  [<b02aa9a4>] schedule_timeout+0x44/0xc0
>  [<b02aa20b>] __sched_text_start+0xb/0x20
>  [<b015a273>] congestion_wait+0x73/0x90
>  [<b012f3f0>] autoremove_wake_function+0x0/0x50
>  [<b0155625>] wb_kupdate+0x95/0xe0
>  [<b0155a80>] pdflush+0x0/0x210
>  [<b0155b8a>] pdflush+0x10a/0x210
>  [<b0155590>] wb_kupdate+0x0/0xe0
>  [<b012f0d2>] kthread+0x42/0x70
>  [<b012f090>] kthread+0x0/0x70
>  [<b0104b6f>] kernel_thread_helper+0x7/0x18
>  =======================

Thanks,
Rafael
