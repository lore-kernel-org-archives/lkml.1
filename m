Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbZE1Wnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbZE1Wnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZE1Wnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:43:45 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:53919 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbZE1Wno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:43:44 -0400
Message-ID: <4A1F135A.6030604@cs.columbia.edu>
Date: Thu, 28 May 2009 18:42:34 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com
Subject: Re: [PATCH 18/38] C/R: core stuff
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>	<1242968132-1044-18-git-send-email-adobriyan@gmail.com>	<20090526131644.GA20920@hallyn.com>	<20090526193503.GB11909@x200.localdomain>	<20090526234436.GB23806@hallyn.com> <20090528153852.GC18256@x200.localdomain>
In-Reply-To: <20090528153852.GC18256@x200.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alexey Dobriyan wrote:
> On Tue, May 26, 2009 at 06:44:36PM -0500, Serge E. Hallyn wrote:
>> Quoting Alexey Dobriyan (adobriyan@gmail.com):
>>> And since you guys showed that just idea of in-kernel checkpointing is not
>>> rejected outright, it doesn't mean that you can drag every single idea too.
>> Can you rephrase here?  I have no idea what you mean by 'drag every single
>> idea'
> 
>   									complexity
>  +-|------------------------------------------------|----------------------|-->
> hypervisor C/R					in-kernel C/R	C/R for unpriviledged
> 								C/R with "leaks"
> 

c/r for unprivileged users is indeed more complex - requires more care.
Keep in mind, however, that most of that are sanity checks that we would
like to have in the code anyway.

c/r with "leaks" is actually a subset of the code that prevents leaks:
simply comment out the leak detection :)

Oren.


> I personally thought in-kernel C/R will be rejected outright, but it wasn't.
> This in theory doesn't mean other two issues should be accepted.
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 
