Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbZBZLSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbZBZLSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 06:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbZBZLSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 06:18:03 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59379 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZBZLSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 06:18:01 -0500
Message-ID: <934198669efa83e838a52284e2c4f8b5.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <1235645076.4645.4781.camel@laptop>
References: <49A6475F.4000502@cn.fujitsu.com>
    <20090226170738.a982057b.kamezawa.hiroyu@jp.fujitsu.com>
    <49A6501B.7040604@cn.fujitsu.com>
    <20090226172234.a931931f.kamezawa.hiroyu@jp.fujitsu.com>
    <49A65455.4030204@cn.fujitsu.com>
    <20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com>
    <344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com>
    <18f6db017e5d44596e828e0753f28e75.squirrel@webmail-b.css.fujitsu.com>
    <1235645076.4645.4781.camel@laptop>
Date: Thu, 26 Feb 2009 20:17:56 +0900 (JST)
Subject: Re: [PATCH] cpuacct: add a branch prediction
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Bharata B Rao" <bharata.rao@gmail.com>,
       "Li Zefan" <lizf@cn.fujitsu.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Paul Menage" <menage@google.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra さんは書きました：
> On Thu, 2009-02-26 at 19:28 +0900, KAMEZAWA Hiroyuki wrote:
>
>> Taking hierarchy mutex while reading will make read-side stable.
>
> We're talking about scheduling here, taking a mutex to stop scheduling
> won't work, nor will it be acceptible to use anything that will.
>
No mutex is necessary, anyway.
hierarchy-walker function completely works well under rcu read lock,
if small jitter is allowed.

Thanks,
-Kame

