Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbYBDN1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbYBDN1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbYBDN1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:27:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57780 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413AbYBDN13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:27:29 -0500
Date: Mon, 4 Feb 2008 05:27:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: for.poige+linux@gmail.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: Both 2.6.24-mm1 and 2.6.24-git11 do NOT "see" any of mine LVM-2
 disks
Message-Id: <20080204052709.12f4e0d3.akpm@linux-foundation.org>
In-Reply-To: <47A71040.5000300@gmail.com>
References: <43d009740802022335y21c3f93ep4e444bef71338045@mail.gmail.com>
	<20080202235103.20dd9768.akpm@linux-foundation.org>
	<47A71040.5000300@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2008 20:16:48 +0700 Igor M Podlesny <for.poige+linux@gmail.com> wrote:

>    Hello, everybody! :-)
> 
> On 2008-02-03 14:51, Andrew Morton wrote:
> > On Sun, 3 Feb 2008 14:35:23 +0700 Igor <for.poige+linux@gmail.com> wrote:
> >> On 02/02/2008, Igor <for.poige+linux@gmail.com> wrote:
> [...]
> >>     And I've tried linux-2.6.24-rc8-mm1 — it fails even running MDs saying
> >> that do_md_run() returning -22.
> > 
> > I'm pretty sure that got fixed, thanks.
> > 
> > I'm trying to get 2.6.24-mm1 out.  Maybe tomorrow - please test that, make
> > sure that we fixed it.
> 
>    Yeah, you've fixed it now, MD's are running OK.
> 
>    Now I can say that both 2.6.24-mm1 and 2.6.24-git11 do NOT "see" any
> of mine LVM-2 disks. pvscan, for e.g., finds nothing at all.

You may find that you need to update your lvm userspace tools.

Alasdair?  other-dm-people?  Did we break^Wchange the userspace interface?

I don't think DM has merged yet, so maybe it was something else.

>    Mine system's configuration is LVM-2 on MD (Software RAID); 2.6.24
> handles it just fine.

I guess it would be helpful if you could tell us the version of your lvm
userspace tools, and identify the distro.

>    P. S. I'm not subscribed to linux-kernel@vger.kernel.org (yet), so
> please keep my e-mail address intact :-) when replying.

Is OK, lots of people are in that situation.  We do reply-to-all as a
matter of course.
