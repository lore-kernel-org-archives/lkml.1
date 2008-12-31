Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbYLaUU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbYLaUU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 15:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYLaUUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 15:20:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:16602 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbYLaUUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 15:20:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OCGP40AaqVJCWONjGSEGAFeH4j72E4rqiGzLWm2KcwLglH3bAIIb6F1YDfnb20DYh8
         SKmp9+eOyJ53pXfnJyK65povq/Od3aejz5rj5tW0vdZNTsT5i0Ko4zbruPmknhcrq39P
         Or66Vk+f0w8Zg17a0ucCLujuRyrLrp6/FjwV4=
Date: Wed, 31 Dec 2008 23:20:14 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: david@lang.hm, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
Message-ID: <20081231202014.GG20882@localhost>
References: <alpine.DEB.1.10.0812301416550.16847@asgard.lang.hm> <87k59hur5f.fsf@basil.nowhere.org> <alpine.DEB.1.10.0812301737320.16936@asgard.lang.hm> <20081231093803.GA20882@localhost> <alpine.DEB.1.10.0812311110320.18334@asgard.lang.hm> <20081231183039.GE20882@localhost> <20081231195005.GT496@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231195005.GT496@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andi Kleen - Wed, Dec 31, 2008 at 08:50:05PM +0100]
| > on the picture you sent me i noticed the message
| > "Your memory is not aligned you need to rebuild your
| > kernel with bigger NODEMAP SIZE shift=20" and then
| > srat code complains about "No NUMA code hash function found"
| > which looks a bit scary. Btw, could you post this picture
| > on some public resource so NUMA people could check it?
| 
| This case used to be handled cleanly (NUMA disabled), but perhaps
| that has regressed. But still it sounds like something is going wrong,
| unless his machine really has a very weird memory map.
| 
| -Andi
| -- 
| ak@linux.intel.com
| 

Andi, it seems I missed where is on the photo NUMA disabled.
At least on picture 2 nodes reported to have place (the nodes
are with 10 and 20 bootmap pages on each node).

		- Cyrill -
