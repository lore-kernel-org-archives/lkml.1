Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbZA2DrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbZA2DrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 22:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZA2DrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 22:47:09 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50614 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbZA2DrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 22:47:05 -0500
Date: Thu, 29 Jan 2009 12:45:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       ext Juha =?UTF-8?B?WXJq7pKU44O7?= <juha.yrjola@solidboot.com>,
       viktor.rosendahl@nokia.com, Trilok Soni <soni.trilok@gmail.com>
Subject: Re: lowmemory android driver not needed?
Message-Id: <20090129124555.b83ea0ae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <d6200be20901281851k45f9692em1379140c8951c195@mail.gmail.com>
References: <2f11576a0901160518g52a3e70endc98fe4792a98b9b@mail.gmail.com>
	<d6200be20901212213x1069762cpd377d04bc5a04a91@mail.gmail.com>
	<20090128234209.A949.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<d6200be20901281851k45f9692em1379140c8951c195@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 18:51:07 -0800
Arve Hjønnevåg <arve@android.com> wrote:

> >> >> static uint32_t lowmem_debug_level = 2;
> >> >> static int lowmem_adj[6] = {
> >> >
> >> > why do you choice [6]?
> >>
> >> We use six levels.
> >
> > if you don't consider other user and other usage case,
> > this file can't merge forever.
> 
> I never expected it to be merged. I wrote it to allow us to ship a product.
> 
Then, please write "DON'T MERGE ME" on the top of patch description.
we can adjust our viewpoints.

Thx,
-Kame

