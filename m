Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbYDJTC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbYDJTC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYDJTCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:02:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51726 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYDJTCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:02:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 10 Apr 2008 21:02:26 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: linux-next: Tree for April 9
To: Ingo Molnar <mingo@elte.hu>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080410094853.GA12543@elte.hu>
Message-ID: <tkrat.4f7ac5ca0bf58526@s5r6.in-berlin.de>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au>
 <47FCF50E.9090703@s5r6.in-berlin.de> <20080410065227.GB30066@elte.hu>
 <20080410174418.ebfe76c3.sfr@canb.auug.org.au>
 <20080410094853.GA12543@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> On Thu, 10 Apr 2008 08:52:27 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > what type of conflict do you have there? If it's a new entry then 
>> > you might be able to fix it by moving the new entry elsewhere in the 
>> > file. Or if i introduced a new entry close to an existing entry you 
>> > modify then i could move my new entry elsewhere.
>> 
>> Commit 523a65f1a7a339e528ca6d6d808516fe195fde03 ("firewire: fw-ohci: 
>> add option for remote debugging") in the ieee1394 tree adds a new 
>> entry just where the sched tree adds
>> 
>> source kernel/trace/Kconfig
> 
> hm, i think in this specific case the new firewire entry should be added 
> after the PROVIDE_OHCI1394_DMA_INIT section. (that's how we extend 
> groups of Kconfig entries anyway) The new trace entries in the scheduler 
> tree follow that pattern and add the new kernel/trace/Kconfig at the 
> right place. So if the firewire entry is added that way this conflict 
> could be avoided.

Indeed, this order of the two options looks more logical now that you
say it.  Update patch will appear on LKML in a minute.

Stephen will still have a conflict in lib/Kconfig.debug when merging the
tests tree, but this happens regardless what we two do because tests is
based on 2.6.25-rc1, and mainline Kconfig.debug has changes post -rc1.
-- 
Stefan Richter
-=====-==--- -=-- -=-=-
http://arcgraph.de/sr/

