Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbXFZOF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbXFZOF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbXFZOFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:05:20 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:7192 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbXFZOFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:05:19 -0400
Message-ID: <46811D41.3020504@sw.ru>
Date: Tue, 26 Jun 2007 18:05:53 +0400
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch -rss] Make RSS accounting display more user friendly
References: <20070620154655.13844.42876.sendpatchset@balbir-laptop>	<6599ad830706211217l65d76d4ehb42f9165bcf45dd@mail.gmail.com>	<467B2F4F.2030101@openvz.org>	<6599ad830706220839h2a556c76he11b78c2c4cdb86e@mail.gmail.com>	<661de9470706222048g638a06dboc0b2e85975a9ba70@mail.gmail.com> <6599ad830706250019h117ff575h156cf112f5778e43@mail.gmail.com> <4681090A.6030805@sw.ru> <46810C68.7020603@linux.vnet.ibm.com>
In-Reply-To: <46810C68.7020603@linux.vnet.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Kirill Korotaev wrote:
> 
>>Paul Menage wrote:
>>
>>>On 6/22/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>>
>>>
>>>>The problem with input in bytes is that the user will have to ensure
>>>>that the input is
>>>>a  multiple of page size, which implies that she would need to use the
>>>>calculator every time.
>>>>
>>>
>>>Having input in bytes seems pretty natural to me. Why not just have
>>>the RSS controller round the input to the nearest page (or whatever
>>>granularity of memory the controller is able to limit at)?
>>
>>totally agree with Paul.
>>
>>Kirill
>>
> 
> Kirill
> 
> If someone assigns a rss_limit of 1 byte and sees a usage of 1 page,
> won't that be confusing. But having said that it's not a big
> change, it should be easy to accommodate.

Well, from my expirience pages are hardly understandable by people.
So bytes are always better and more convinient for non-programmers.
Rounding is not that big issue, since people still get the result
they expect (unlike to the case when they mess up with the page size).

Thanks,
Kirill

P.S. 1 byte limit is not that common :)

