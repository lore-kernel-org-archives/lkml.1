Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbZA0HCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbZA0HCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZA0HCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:02:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57379 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZA0HCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:02:38 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Torvalds <torvalds@linux-foundation.org>,
       Arve Hj?nnev?g <arve@android.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Linus@smtp1.linux-foundation.org,
       Paul Menage <menage@google.com>
In-Reply-To: <20090126195622.1d5bf488@lxorguk.ukuu.org.uk>
References: <20090126195431.GC504@balbir.in.ibm.com> <20090126195622.1d5bf488@lxorguk.ukuu.org.uk>
Message-Id: <20090127155825.D476.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 27 Jan 2009 16:02:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > > As Alan Cox suggested/wondered in this thread, 
> > > http://lkml.org/lkml/2009/1/12/235 , this is a container group based approach 
> > > to override the oom killer selection without losing all the benefits of the 
> > > current oom killer heuristics and oom_adj interface.
> > > 
> > > It adds a tunable oom.victim to the oom cgroup. The oom killer will kill the 
> > > process using the usual badness value but only within the cgroup with the 
> > > maximum value for oom.victim before killing any process from a cgroup with a 
> > > lesser oom.victim number. Oom killing could be disabled by setting 
> > > oom.victim=0.
> > 
> > Looking at the patch, I wonder if it is time for user space OOM
> > notifications that were discussed during the containers mini-summit.
> > The idea is to inform user space about OOM's and let user space take
> > action, if no action is taken, the default handler kicks in.
> 
> The OLPC folks (Marcelo I believe) posted code for this and I believe
> OLPC is using this functionality internally so that under memory pressure
> (before we actually hit OOM) programs can respond by doing stuff like
> evicting caches.

Confused.

As far as I know, people want the method of flexible cache treating.
but oom seems less flexible than userland notification.

Why do you think notification is bad?


