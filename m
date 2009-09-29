Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbZI2GdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbZI2GdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 02:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbZI2Gc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 02:32:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54276 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZI2Gc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 02:32:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 29 Sep 2009 15:30:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, tglx@linutronix.de
Subject: Re: mmotm 2009-09-09-22-56 uploaded
Message-Id: <20090929153049.15892a07.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4AC1A6FB.1080304@suse.de>
References: <4AC1A6FB.1080304@suse.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 11:49:39 +0530
Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Hi all,
> 
> On Thu, Sep 10, 2009 at 11:31 AM,  <akpm@linux-foundation.org> wrote:
> > The mm-of-the-moment snapshot 2009-09-09-22-56 has been uploaded to
> >
> >   http://userweb.kernel.org/~akpm/mmotm/
> >
> > and will soon be available at
> >
> >   git://git.zen-sources.org/zen/mmotm.git
> >
> 
> With this snapshot plus fixes, I'm unable to limit the memory using the
> kernel command line switch "mem=nn" on a x86_64 box. Is this the
> expected behavior?
> 
> Using "cgroup_disable=memory" together with "mem=nn" switch didn't help.

memory cgroup is independent from mem=nn switch.
(But yes, size of page_cgroup array is affected by size of memory.)

> Am I supposed to use some other switch along with this?
> 
Hmm, Isn't it related to this ?

http://patchwork.kernel.org/patch/48787/

Added Ingo, Thomas to CC. I'm sorry if above one is fixed and mem= should work.

Regards,
-Kame

