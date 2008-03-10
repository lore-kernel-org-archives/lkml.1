Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbYCJSs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbYCJSs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYCJSsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:48:50 -0400
Received: from saeurebad.de ([85.214.36.134]:33855 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbYCJSst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:48:49 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Remove redundant display of free swap space in show_mem()
References: <87abl68rdd.fsf@saeurebad.de>
	<Pine.LNX.4.64.0803101720580.3398@blonde.site>
Date: Mon, 10 Mar 2008 19:47:02 +0100
In-Reply-To: <Pine.LNX.4.64.0803101720580.3398@blonde.site> (Hugh Dickins's
	message of "Mon, 10 Mar 2008 17:28:37 +0000 (GMT)")
Message-ID: <87wsoa76xl.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Hugh Dickins <hugh@veritas.com> writes:

> On Mon, 10 Mar 2008, Johannes Weiner wrote:
>> From: Johannes Weiner <hannes@saeurebad.de>
>> 
>> show_free_areas() already displays free swap space, no need to do it a
>> second time in show_mem() which calls the former anyway.
>> 
>> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>
> I heartily approve of this; and yes, it's the per-arch one which should
> go (since its "alignment" looks nasty).  But there's a lot more arches
> than just x86 which should be fixed (and so rather more work, preparing
> those patches for the various maintainers) - is that something you'd
> have time to do?  (Don't worry, "No" is a perfectly fair answer, and
> it's no way essential that all change at once.)

Yes, I will whip something up.  Thanks for the feedback.

	Hannes
