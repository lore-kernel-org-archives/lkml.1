Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbYAZOqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbYAZOqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 09:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYAZOqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 09:46:04 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52529 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYAZOqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 09:46:02 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <479B4795.2040202@s5r6.in-berlin.de>
Date: Sat, 26 Jan 2008 15:45:41 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, cate@cateee.net, rjw@sisk.pl, Valdis.Kletnieks@vt.edu,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: using LKML for subsystem development
References: <479A75D4.6070607@s5r6.in-berlin.de>	<479A8203.40804@s5r6.in-berlin.de>	<20080126112820.GA10563@elte.hu> <20080126.060705.53192768.davem@davemloft.net>
In-Reply-To: <20080126.060705.53192768.davem@davemloft.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat, 26 Jan 2008 12:28:20 +0100
> 
>> Filter on all mails from David S. Miller if you are interested in 
>> networking topics. You'll have a really good grasp of what's going on in 
>> that area, without having to invest too much time.
> 
> That's a very poor filter, I don't write much code lately in the
> networking.
> 
> I only provide theoretical direction in a few specific areas I care
> about.
> 
> As Ingo already knows, I think this "put everything on lkml" argument
> is bogus.

If people started filtering by stefanr to follow IEEE 1394 subsystem
development, I would have to stop drawing myself into SCSI/ Kconfig menu
layout/ coding style related discussions and meta discussions such as
this.  Which might actually be a good move anyway.  :-)

> And about bisectability, every time I apply a networking patch I do at
> the very least a "allmodconfig" build with just that new patch added,
> for every patch.  Often I do more extensive build testing.
> 
> And when I rebase the tree, I rerun this check after each
> patch gets re-applied to a new base tree.
> 
> In fact I'm working on such issues as I fly over the Australia
> for LCA08 :-)
> 
> So this isn't an issue that posting to lkml is going to help.

Well, bisectability issues apparently occur primarily in the merge
result after merges of cross-subsystem changes.  So, things like the new
pre-merge tree which James Bottomley set up might actually help with
this issue.
-- 
Stefan Richter
-=====-==--- ---= ==-=-
http://arcgraph.de/sr/
