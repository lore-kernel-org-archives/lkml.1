Return-Path: <linux-kernel-owner+w=401wt.eu-S1751398AbZI1FVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbZI1FVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 01:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbZI1FV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 01:21:29 -0400
Received: from mail.crca.org.au ([67.207.131.56]:35287 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbZI1FV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 01:21:29 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4AC04800.70708@crca.org.au>
Date: Mon, 28 Sep 2009 15:22:08 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
References: <4AB9A0D6.1090004@crca.org.au>	<20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>	<4ABC80B0.5010100@crca.org.au>	<20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com>	<4AC0234F.2080808@crca.org.au>	<20090928120450.c2d8a4e2.kamezawa.hiroyu@jp.fujitsu.com>	<20090928033624.GA11191@localhost>	<20090928125705.6656e8c5.kamezawa.hiroyu@jp.fujitsu.com>	<4AC03D9C.3020907@crca.org.au> <20090928135315.083aca18.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090928135315.083aca18.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

KAMEZAWA Hiroyuki wrote:
> Seems good to me.
> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> But
>> +	if (vma->vm_hints)
>> +		return 0;
>>  	return 1;
> 
> Maybe adding a comment (or more detailed patch description) is necessary.

Thinking about this some more, I think we should also be looking at whether the new hints are non zero. Perhaps I should just add the new value to the
function parameters and be done with it.

Nigel

