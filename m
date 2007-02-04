Return-Path: <linux-kernel-owner+w=401wt.eu-S1751635AbXBDAk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbXBDAk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 19:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbXBDAk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 19:40:28 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:55701 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbXBDAk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 19:40:28 -0500
Message-ID: <45C52B53.3040303@student.ltu.se>
Date: Sun, 04 Feb 2007 01:39:47 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
CC: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: A CodingStyle suggestion
References: <20070203215848.GA10440@Ahmed> <45C51310.6070304@student.ltu.se> <20070204000532.GA20721@Ahmed>
In-Reply-To: <20070204000532.GA20721@Ahmed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ahmed S. Darwish wrote:
> On Sat, Feb 03, 2007 at 11:56:16PM +0100, Richard Knutsson wrote:
>   
>> Ahmed S. Darwish wrote:
>>     
>>> Hi all,
>>>
>>> In CodingStyle Chapter 16 "Function return value and names", why not
>>> adding a comment about the favorable community way of checking the return
>>> value. ie:
>>>
>>> ret = do_method();
>>> if (ret) {
>>>   /* deal with error */
>>> }
>>>
>>> and not other ways like:
>>>
>>> if (do_method()) or 
>>>       
>> So:
>>
>> if (is_true()) {
>> 	/* do something */
>> }
>>
>> is alright then? If so, I agree, but please make it real clear in the 
>> document ;)
>>     
>
> Good catch :). A small grep of `access_ok' reveals that it's always used in the 
> form of:
> if (!access_ok()) { .. }
>
> I can conclude that verbal/imperative methods like `kmalloc, add_work' be 
> checked as:
> ret = do_work();
> if (ret) { ... }
> and predicate methods like `acess_ok, pci_dev_present' be checked like:
> if (!access_ok) { ... }
> if (pci_dev_present) { ...}
>
> Any comments ?
>   
Not really, I agree on this :)

Richard Knutsson

