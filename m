Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbXJZAiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbXJZAiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbXJZAh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:37:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbXJZAh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:37:56 -0400
Date: Fri, 26 Oct 2007 01:37:53 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] dm: noflush resizing (0/3)
Message-ID: <20071026003753.GO10006@agk.fab.redhat.com>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	linux-kernel@vger.kernel.org
References: <471FB83D.4060307@ce.jp.nec.com> <20071025012456.GK10006@agk.fab.redhat.com> <4720A59A.8060001@ce.jp.nec.com> <20071025144833.GN10006@agk.fab.redhat.com> <4720E479.4020906@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4720E479.4020906@ce.jp.nec.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 02:46:17PM -0400, Jun'ichi Nomura wrote:
> So as far as I understand, the point is:
>   1. it's preferable to resize inode after the resume, if possible

Not quite - I'm not expressing a preference yet.

I'm saying the patches you presented were one option to resolve the
problem, but it was not obvious to me they are the only option and I
wanted to see a deeper analysis (keeping in mind the general direction
I want the device-mapper code to be heading in).

In other words, an analysis that draws out the conflict at the heart of
this problem, and whether the problem we have with this locking is
intrinsic to the current design or just a matter of implementation that
can be fixed with some re-ordering or tweaks to the usage rules or types
of the locks.

Alasdair
-- 
agk@redhat.com
