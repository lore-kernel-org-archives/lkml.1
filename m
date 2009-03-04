Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZCDHut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZCDHut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 02:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZCDHuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 02:50:39 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33389 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZCDHui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 02:50:38 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49AE32B5.9040603@s5r6.in-berlin.de>
Date: Wed, 04 Mar 2009 08:50:13 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large amount of scsi-sgpool objects
References: <49ACF8FE.2020904@panasas.com>	 <1236093718.3263.3.camel@localhost.localdomain>	 <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>	 <1236097526.3263.17.camel@localhost.localdomain>	 <20090303192212.GA20705@elte.hu>	 <1236115544.15993.22.camel@localhost.localdomain>	 <20090303214454.GA8288@elte.hu>	 <1236119990.24019.35.camel@localhost.localdomain>	 <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de>	 <20090303234834.GA13389@elte.hu>  <49AE221D.9010909@s5r6.in-berlin.de> <1236150752.6049.19.camel@marge.simson.net>
In-Reply-To: <1236150752.6049.19.camel@marge.simson.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Wed, 2009-03-04 at 07:39 +0100, Stefan Richter wrote:
>> Ingo Molnar wrote:
>>> Yeah, these commits are in none of the topic branches that are 
>>> the git base of development, they are all already in a separate 
>>> branch named "tip:out-of-tree".
>> So people should remember to retry without out-of-tree before reporting
>> problems == remember to report against the development base.
> 
> I'll bite, how does a gut-fu white belt accomplish that?

How to do it is currently not quite obvious
  - for linux-2.6-x86.git users because the master branch contains
    out-of-tree.¹  Or maybe nobody should use the master branch,
    I don't know.
  - Ditto for linux-2.6.tip.git.²
It was also impossible for users of the -rt patchset because the faulty
patch was obviously included in a base patch in the -rt patch series.³

As I said, I recommend that people do not receive those off-topic
patches by default, only on demand.  (Because I sometimes work with -rt
users.)

¹)http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git;a=commit;h=4239438b08fe8ec149ddc530238ca131bf88d290
²)http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=4239438b08fe8ec149ddc530238ca131bf88d290
³)http://lkml.org/lkml/2009/3/3/424
-- 
Stefan Richter
-=====-==--= --== --=--
http://arcgraph.de/sr/
