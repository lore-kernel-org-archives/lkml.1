Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbYGJRMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbYGJRMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYGJRMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:12:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37547 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbYGJRMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:12:40 -0400
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 - Object creation
	with a specified id)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Kirill Korotaev <dev@parallels.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net, Andrew Morton <akpm@linux-foundation.org>,
       nick@nick-andrew.net, Alexey Dobriyan <adobriyan@gmail.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <m1y74a7b4w.fsf@frodo.ebiederm.org>
References: <20080418054459.891481000@bull.net>
	 <20080422193612.GA15835@martell.zuzino.mipt.ru>
	 <1208890580.17117.14.camel@nimitz.home.sr71.net>
	 <20080422210130.GA15937@martell.zuzino.mipt.ru>
	 <1208904967.17117.51.camel@nimitz.home.sr71.net>
	 <480ED9D5.1010906@parallels.com> <480FE037.2010302@cs.columbia.edu>
	 <m1y74a7b4w.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 10:12:29 -0700
Message-Id: <1215709949.9398.15.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-09 at 18:58 -0700, Eric W. Biederman wrote:
> In the worst case today we can restore a checkpoint by replaying all of
> the user space actions that took us to get there.  That is a tedious
> and slow approach.

Yes, tedious and slow, *and* minimally invasive in the kernel.  Once we
have a tedious and slow process, we'll have some really good points when
we try to push the next set of patches to make it less slow and tedious.
We'll be able to describe an _actual_ set of problems to our fellow
kernel hackers.

So, the checkpoint-as-a-corefile idea sounds good to me, but it
definitely leaves a lot of questions about exactly how we'll need to do
the restore.

-- Dave

