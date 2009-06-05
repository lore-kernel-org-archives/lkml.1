Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZFEO7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZFEO7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbZFEO7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:59:33 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:38350 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376AbZFEO7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:59:31 -0400
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
From: Jon Masters <jonathan@jonmasters.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>, axboe@kernel.dk,
       hirofumi@mail.parknet.co.jp, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       adrian.hunter@nokia.com, artem.bityutskiy@nokia.com
In-Reply-To: <ac3eb2510906040553j294f1015wfb7deb4b4fc63afc@mail.gmail.com>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
	 <20090603115611.6bbbaf55.akpm@linux-foundation.org>
	 <ac3eb2510906040553j294f1015wfb7deb4b4fc63afc@mail.gmail.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Fri, 05 Jun 2009 03:25:22 -0400
Message-Id: <1244186723.11597.111.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-04 at 14:53 +0200, Kay Sievers wrote:
> On Wed, Jun 3, 2009 at 20:56, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed,  3 Jun 2009 18:05:14 +0300 Denis Karpov <ext-denis.2.karpov@nokia.com> wrote:
> 
> > hm, I'm uncertain on the desirability or otherwise of the
> > overall feature.

I think the idea is a good one. It allows a distribution to take more
proactive measures before services just start dying randomly later. I
could see this nicely wrapped up with some kind of GUI dialog presented
to the desktop user announcing impending doom, too.

> Uevents should not be used for error reporting

Not as currently implemented - but I think the idea of having kernel
events for this kind of thing isn't a bad one, nor is the idea of
listening on a netlink socket for news about them rather than writing
library code to poll whatever procfs file and parse its content.

Jon.


