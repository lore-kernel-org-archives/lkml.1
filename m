Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbZBZKpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbZBZKpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZBZKow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:44:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:60396 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbZBZKov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:44:51 -0500
Subject: Re: [PATCH] cpuacct: add a branch prediction
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <18f6db017e5d44596e828e0753f28e75.squirrel@webmail-b.css.fujitsu.com>
References: <49A6475F.4000502@cn.fujitsu.com>
	 <20090226170738.a982057b.kamezawa.hiroyu@jp.fujitsu.com>
	 <49A6501B.7040604@cn.fujitsu.com>
	 <20090226172234.a931931f.kamezawa.hiroyu@jp.fujitsu.com>
	 <49A65455.4030204@cn.fujitsu.com>
	 <20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com>
	 <344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com>
	 <18f6db017e5d44596e828e0753f28e75.squirrel@webmail-b.css.fujitsu.com>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 11:44:36 +0100
Message-Id: <1235645076.4645.4781.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 19:28 +0900, KAMEZAWA Hiroyuki wrote:

> Taking hierarchy mutex while reading will make read-side stable.

We're talking about scheduling here, taking a mutex to stop scheduling
won't work, nor will it be acceptible to use anything that will.



