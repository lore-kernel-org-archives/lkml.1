Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYBDRAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYBDRAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYBDRAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:00:07 -0500
Received: from emroute3.ornl.gov ([160.91.4.110]:57180 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbYBDRAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:00:05 -0500
Date: Mon, 04 Feb 2008 12:00:01 -0500
From: David Dillow <dillowda@ornl.gov>
Subject: Re: Integration of SCST in the mainstream Linux kernel
In-reply-to: <e2e108260802040553j2f3bf8c2n9fae132e000990f7@mail.gmail.com>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Message-id: <1202144401.11599.2.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
 <1201639331.3069.58.camel@localhost.localdomain> <47A05CBD.5050803@vlnb.net>
 <47A7049A.9000105@vlnb.net>
 <e2e108260802040553j2f3bf8c2n9fae132e000990f7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-04 at 14:53 +0100, Bart Van Assche wrote:
> Another issue I have to look further into is that dd and xdd report
> different results for very large block sizes (> 1 MB).

Be aware that xdd reports 1 MB as 1000000, not 1048576. Though, it looks
like dd is the same, so that's probably not helpful. Also, make sure
you're passing {i,o}flag=direct to dd if you're using -dio in xdd to be
sure you are comparing apples to apples.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


