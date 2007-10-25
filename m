Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbXJYGur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbXJYGur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 02:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbXJYGuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 02:50:39 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50740 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbXJYGui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 02:50:38 -0400
Message-ID: <47203C21.2010505@ah.jp.nec.com>
Date: Thu, 25 Oct 2007 15:48:01 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>, kdb@oss.sgi.com
Subject: Re: [PATCH 0/2] add new notifier function ,take2
References: <471700F4.1080200@ah.jp.nec.com> <20071018080621.GB8779@in.ibm.com> <47171ED9.7010907@ah.jp.nec.com> <200710212200.04361.nickpiggin@yahoo.com.au>
In-Reply-To: <200710212200.04361.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>>> Is it possible to use a single bit of common code and a single
>>> notifier for these things? Or is it too difficult?
>> >
>> > I'm sorry, I can't understand your image well. I'd like to know details of
>> > your image.
> 
> Rather than have each of "RAS tools" have their own notifier, and have
> the user specify the priority of the notifiers, introduce some layer
> which _knows_ that, for example, only one of these subsystems will be
> called (it could arbitrate, perhaps distinguish between destructive and
> non-destructive ones). It would need only a single notifier, but would
> then have a specific way of calling into the ras modules.
> 
> Does this make sense? I guess it is a lot more work to do, so maybe your
> solution is the best one for now.

Hi Nick,

Thank you for your explanation. I understand. :-)

This is crash_stop (the common infrastructure for debug tools) by Keith Owens.
http://www.mail-archive.com/linux-arch@vger.kernel.org/msg01929.html

Is it same as your idea? I think it is very nice solution for debug tools
conflict problem.

By the way, on old notify_chain, if admin wants to change the list order, admin
have to recompile the kernel. My patches add new *generic* notify_chain which
admin can modify the list order. My patches are not only for RAS tools problem.

I'm happy if both patches are merged into mainline. :-)

Thanks,
  Takenori
