Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbZGABYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbZGABYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762743AbZGABFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:05:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48914 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762454AbZGABFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:05:44 -0400
Date: Wed, 1 Jul 2009 10:04:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] cgroup: exlclude release rmdir
Message-Id: <20090701100412.d59122d9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830906301727wcb6b292uc3c46451f8844392@mail.gmail.com>
References: <20090630180109.f137c10e.kamezawa.hiroyu@jp.fujitsu.com>
	<20090630180344.d7274644.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830906300215q56bda5ccnc99862211dc65289@mail.gmail.com>
	<20090630182304.8049039c.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830906300918i3e3f8611r6d6fb7873c720c70@mail.gmail.com>
	<20090701084037.2c3f53f7.nishimura@mxp.nes.nec.co.jp>
	<20090701090959.4cbdb03e.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830906301727wcb6b292uc3c46451f8844392@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 17:27:02 -0700
Paul Menage <menage@google.com> wrote:

> It only looks "cosmeticized" because of the evolution of your fix. The
> first patch added a new function that exposed internal details of
> cgroups, and the second patch removes the addition in favour of a
> different new function that doesn't expose internal details as much; a
> single patch that just adds the simpler new function is easier to
> judge as intuitively correct (separately from Daisuke's testing) than
> one that exposes more internal details.
> 
ok, I'll post again.

BTW, do you have patches for NOOP/signal cgroup we discussed a half year ago ?

Thanks,
-Kame

> Paul
> 

