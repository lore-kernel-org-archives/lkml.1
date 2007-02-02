Return-Path: <linux-kernel-owner+w=401wt.eu-S1946069AbXBBVBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946069AbXBBVBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 16:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946070AbXBBVBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 16:01:39 -0500
Received: from main.gmane.org ([80.91.229.2]:41920 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946069AbXBBVBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 16:01:38 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH] sed s/gawk/awk/ scripts/gen_init_ramfs.sh
Date: Fri, 2 Feb 2007 21:01:04 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnes7a58.m64.olecom@flower.upol.cz>
References: <200701151624.18033.rob@landley.net> <20070115221146.GA12698@uranus.ravnborg.org> <20070123164944.db8acbad.akpm@osdl.org> <20070202163620.GG3754@stusta.de>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Adrian Bunk
> Newsgroups: gmane.linux.kernel
> Subject: Re: [PATCH] sed s/gawk/awk/ scripts/gen_init_ramfs.sh
> Date: Fri, 2 Feb 2007 17:36:20 +0100
[]
> On Tue, Jan 23, 2007 at 04:49:44PM -0800, Andrew Morton wrote:
>> On Mon, 15 Jan 2007 23:11:46 +0100
>> Sam Ravnborg <sam@ravnborg.org> wrote:
>> 
>> > On Mon, Jan 15, 2007 at 04:24:17PM -0500, Rob Landley wrote:
>> > > Signed-off-by: Rob Landley <rob@landley.net>
>> > Acked-by: Sam Ravnborg <sam@ravnborg>
>> > 
>> > > Use "awk" instead of "gawk".
>> > > 
>> > > -- 
>> > > 
>> > > There's a symlink from awk to gawk if you're using the gnu tools, but no
>> > > symlink from gawk to awk if you're using BusyBox or some such.  (There's a
>> > > reason for the existence of standard names.  Can we use them please?)
>> 
>> If the kernel is being compiled on a non-Linux system (eg: legacy Unix)
>> then it is, I guess, possible for `awk' and `gawk' to offer different
>> features.  If the kernel's use of gawk uses GNU extensions then this patch
>> might break things on such a system.
>> 
>> I guess we'll find out...
>
> Not only legacy systems.
>
> E.g. in Debian GNU/Linux you must have at least one AWK implementation 
> installed, and awk is a symlink to one of them (both is done by the 
> package manager).
>
> Available AWK implementations are:
> - GNU AWK 
> - Mawk
> - the original AWK

Well, i'm looking for anyone to comment on my respond to this "issue".
Probably noone has much time to do this. Anyway, please see my patch:

	 Message-ID: <slrnes021q.f71.olecom@flower.upol.cz>
	 Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/488044>

Thanks.

____

