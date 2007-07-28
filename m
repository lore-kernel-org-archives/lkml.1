Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbXG1Flw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbXG1Flw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 01:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbXG1Flp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 01:41:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46196 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbXG1Fln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 01:41:43 -0400
Date: Sat, 28 Jul 2007 14:43:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tony.luck@intel.com,
       nickpiggin@yahoo.com.au, Zoltan.Menyhart@bull.net
Subject: Re: [PATCH] flush cache fixes for ia64 [1/2] migration fix
Message-Id: <20070728144306.409b4c6c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070728070609.3a775842.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070727133657.8c9c6803.kamezawa.hiroyu@jp.fujitsu.com>
	<20070727133843.6cd3f57a.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0707270934300.15619@schroedinger.engr.sgi.com>
	<20070728070609.3a775842.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2007 07:06:09 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 27 Jul 2007 09:39:16 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > This will have no effect on x86_64, ia64 and i386. Maybe useful for 
> > virtually mapped platforms (parisc)?
> > 
> yes.
> 
Ahh... but I should notify you that I added sync_icahce_dcache() (for ia64)
here. I'll post take5.

Thanks,
-Kame

