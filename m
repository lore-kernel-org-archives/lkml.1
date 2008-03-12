Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbYCLBXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbYCLBXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 21:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYCLBXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 21:23:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbYCLBXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 21:23:04 -0400
Date: Tue, 11 Mar 2008 18:22:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler fixes
Message-Id: <20080311182214.a2c97892.akpm@linux-foundation.org>
In-Reply-To: <200803112330.59149.rjw@sisk.pl>
References: <20080311154837.GA27219@elte.hu>
	<200803112330.59149.rjw@sisk.pl>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 23:30:58 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday, 11 of March 2008, Ingo Molnar wrote:
> > 
> > Linus, please pull the latest scheduler fixes git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git for-linus
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> > ------------------>
> > Gregory Haskins (2):
> >       Revert "cpu hotplug: adjust root-domain->online span in response to hotplug event"
> >       keep rd->online and cpu_online_map in sync
> 
> Does it fix the poweroff problem reported by Andrew?
> 

Yes, this regression is fixed in current mainline.
