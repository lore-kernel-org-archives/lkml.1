Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbXGPXkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbXGPXkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXGPXj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:39:59 -0400
Received: from main.gmane.org ([80.91.229.2]:51823 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbXGPXj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:39:58 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Date: Tue, 17 Jul 2007 00:39:48 +0100
Message-ID: <yw1xr6n76hq3.fsf@thrashbarg.mansr.com>
References: <8FO1e-2jW-35@gated-at.bofh.it> <8FYWD-2eS-7@gated-at.bofh.it> <8GdsH-8dc-13@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it> <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it> <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it> <E1  <469BF104.1040703@gmail.com> <1184628395.8707.15.camel@segv.aura.of.mankind>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: agrajag.inprovide.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (Double Solitaire, linux)
Cancel-Lock: sha1:Ux66Lg73z71SBWrLc4NKsPkA/PM=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

utz lehmann <lkml123@s2y4n2c.de> writes:

> On Tue, 2007-07-17 at 00:28 +0200, Rene Herman wrote:
>> Given that as Arjan stated Fedora and even RHEL have been using 4K
>> stacks for some time now, and certainly the latter being a
>> distribution which I would expect to both host a relatively large
>> number of lvm/md/xfs and what stackeaters have you users and to be
>> fairly conservative with respect to the chances of scribbling over
>> kernel memory (I'm a trusting person...) it seems there might at
>> this stage only be very few offenders left.
>
> I have to recompile the fedora kernel rpms (fc6, f7) with 8k stacks on
> my i686 server. It's using NFS -> XFS -> DM -> MD (raid1) -> IDE disks.
> With 4k stacks it crash (hang) within minutes after using NFS.
> With 8k stacks it's rock solid. No crashes within months.

Running either vanilla or Gentoo kernels, I've had no luck at all with
4k stacks.  On SATA+MD(raid1)+LVM+XFS I've had numerous crashes when
doing even light I/O.  One particularly crash-prone scenario is
writing to random locations in sparse files, thus forcing new blocks
to be allocated.

I don't have dedicated testing machines, so I can't afford the time
and potential data loss of testing this regularly.  I have no shortage
on RAM with 8k stacks, so for me the choice is quite simple.

-- 
Måns Rullgård
mans@mansr.com

