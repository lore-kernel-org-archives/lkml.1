Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbYFSJP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbYFSJP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYFSJPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:15:48 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:45299 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYFSJPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:15:47 -0400
Message-ID: <485A2341.9020406@s5r6.in-berlin.de>
Date: Thu, 19 Jun 2008 11:13:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: benh@kernel.crashing.org, ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Request for discussion on when to merge
 drivers
References: <1213802866.3515.24.camel@localhost.localdomain>	 <1213831894.8011.29.camel@pasglop> <1213832399.3515.109.camel@localhost.localdomain>
In-Reply-To: <1213832399.3515.109.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Thu, 2008-06-19 at 09:31 +1000, Benjamin Herrenschmidt wrote:
>> linux-next should, imho, exclusively be for things we are pretty much
>> commited to merge in the next release. ie, a staging place to fixup
>> things like build breakages, patch conflicts, etc...
>> 
>> Or else, it will just be another -mm ....
> 
> Well, as Greg said for his driver staging tree, I think we can elide
> this requirement for new drivers.  The good thing about drivers is that
> there's nothing we're really doing to break anything: before the driver
> the hardware was just plane unusable with Linux after the driver well,
> we're hoping it might be ...

This requires that the staged driver does not contain build bugs on any
architecture.

Besides, the definition of what we published in -next so far was:

    Everything in -next is *merge-ready* now (from a subsystem
    maintainer's POV).  The only reason that it is not merged yet
    is that Linus doesn't have a merge window open right now.

And the goal of -next was to check for potential integration problems
that cannot be detected in a maintainer's tree.

So IMO the question is not whether to put stuff which is not ready to be
merged into -next.  It shouldn't, IMO.  The questions rather are:
  - What are criteria for merge-readiness of drivers?
    (When do we have to / are we able to address issues like CamelCase
    names or use of obsolete APIs --- before or after merge?)
  - How to publish drivers which are not yet merge-ready but should get
    into the hands of testers?

IMO the answer to the latter question is still not -next, because the
testing that -next gets is (from what I understood) also with the
specific goal to detect potential integration problems.  Remember, you
publish code in -next of which you can say:  This is ready for mainline,
except that there is little experience yet WRT potential integration issues.
-- 
Stefan Richter
-=====-==--- -==- =--==
http://arcgraph.de/sr/
