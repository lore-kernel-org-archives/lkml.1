Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbYDXH0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbYDXH0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 03:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYDXH0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 03:26:22 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:37997 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbYDXH0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 03:26:22 -0400
Message-ID: <48103002.5090806@parallels.com>
Date: Thu, 24 Apr 2008 11:00:18 +0400
From: Kirill Korotaev <dev@parallels.com>
Organization: Parallels
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net, Andrew Morton <akpm@linux-foundation.org>,
       nick@nick-andrew.net, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 -  Object	creation
 with a specified id)
References: <20080418054459.891481000@bull.net>	 <20080422193612.GA15835@martell.zuzino.mipt.ru>	 <1208890580.17117.14.camel@nimitz.home.sr71.net>	 <20080422210130.GA15937@martell.zuzino.mipt.ru>	 <1208904967.17117.51.camel@nimitz.home.sr71.net>	 <480ED9D5.1010906@parallels.com> <1208964798.17117.72.camel@nimitz.home.sr71.net>
In-Reply-To: <1208964798.17117.72.camel@nimitz.home.sr71.net>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah... we talked with Andrew yesterday. He mostly agrees with a black box.
He also said an interesting idea, that if you need compatibility
between the kernels (like we for example, support for migration from 2.6.9 to 2.6.18 in OpenVZ)
you can do image conversion in user-space... Though I think we will prefer simply to have
a compatibility patch for specific kernel versions in our kernel tree (not in mainstream).

Definitely, other ideas/opinions are welcome.

Kirill


Dave Hansen wrote:
> On Wed, 2008-04-23 at 10:40 +0400, Kirill Korotaev wrote:
>> Having all this functionality in a signle syscall we specifically CLAIM a black box,
>> and that no one can use this interfaces for something different from checkpoint/restore.
>>
>> So I think we have to know what other maintainers think before we can go.
> 
> I completely agree.
> 
> Have you asked any particular maintainers what they think?
> 
> -- Dave
> 
> 
