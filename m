Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbZIIDqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbZIIDqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 23:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbZIIDqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 23:46:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51973 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbZIIDq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 23:46:29 -0400
Message-ID: <4AA724CB.1070401@cn.fujitsu.com>
Date: Wed, 09 Sep 2009 11:45:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com> <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com> <1251129384.22398.7166.camel@nimitz> <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com> <1251150156.22398.8289.camel@nimitz> <alpine.DEB.2.00.0908241540480.12448@chino.kir.corp.google.com> <alpine.DEB.1.00.0909081511590.26432@chino.kir.corp.google.com> <4AA70D4F.3040503@cn.fujitsu.com> <alpine.DEB.1.00.0909081959030.5084@chino.kir.corp.google.com> <4AA72175.5000108@cn.fujitsu.com> <alpine.DEB.1.00.0909082034470.8334@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0909082034470.8334@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11:41, David Rientjes wrote:
> On Wed, 9 Sep 2009, Li Zefan wrote:
> 
>> I was not talking about ftrace_ret_stack, I was talking about
>> struct ftrace_page and struct ftrace_profile_page. ;)
>>
> 
> Gack, ftrace_page would probably be better off simply using the flex list 
> implementation I suggested which constructs a list from page->lru since it 
> doesn't appear to require indexing into the array, it simply requires an 
> iteration in all cases (or am I wrong?).  Flex lists could easily be made 
> to support seqfiles.
> 

Right, iteration is needed but indexing is not. I thought
about flex list too, flex array has some limitations which
make it hard to find a real user.

