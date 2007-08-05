Return-Path: <linux-kernel-owner+w=401wt.eu-S1760942AbXHEVWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942AbXHEVWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 17:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbXHEVWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 17:22:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbXHEVWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 17:22:35 -0400
To: Brice Figureau <brice+lklm@daysofwonder.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070803123712.987126000@chello.nl>
	<alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
	<20070804063217.GA25069@elte.hu>
	<loom.20070805T190600-28@post.gmane.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Aug 2007 00:17:00 +0200
In-Reply-To: <loom.20070805T190600-28@post.gmane.org>
Message-ID: <p734pjdmxsz.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brice Figureau <brice+lklm@daysofwonder.com> writes:
> 
>  2) I _still_ don't get the "performances" of 2.6.17, but since that's the
> better combination I could get, I think there is IMHO progress in the right
> direction (to be compared to no progress since 2.6.18, that's better :-)).

If you could characterize your workload well (e.g. how many disks,
what file systems, what load on mysql) perhaps it would be possible
to reproduce the problem with a test program or a mysql driver.
Then it could be bisected.

-Andi
