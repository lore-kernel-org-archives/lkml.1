Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbXFZMzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbXFZMzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 08:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbXFZMzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 08:55:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45437 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbXFZMzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 08:55:24 -0400
Message-ID: <46810C68.7020603@linux.vnet.ibm.com>
Date: Tue, 26 Jun 2007 08:54:00 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Kirill Korotaev <dev@sw.ru>
CC: Paul Menage <menage@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch -rss] Make RSS accounting display more user friendly
References: <20070620154655.13844.42876.sendpatchset@balbir-laptop>	<6599ad830706211217l65d76d4ehb42f9165bcf45dd@mail.gmail.com>	<467B2F4F.2030101@openvz.org>	<6599ad830706220839h2a556c76he11b78c2c4cdb86e@mail.gmail.com>	<661de9470706222048g638a06dboc0b2e85975a9ba70@mail.gmail.com> <6599ad830706250019h117ff575h156cf112f5778e43@mail.gmail.com> <4681090A.6030805@sw.ru>
In-Reply-To: <4681090A.6030805@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Korotaev wrote:
> Paul Menage wrote:
>> On 6/22/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>
>>> The problem with input in bytes is that the user will have to ensure
>>> that the input is
>>> a  multiple of page size, which implies that she would need to use the
>>> calculator every time.
>>>
>>
>> Having input in bytes seems pretty natural to me. Why not just have
>> the RSS controller round the input to the nearest page (or whatever
>> granularity of memory the controller is able to limit at)?
> 
> totally agree with Paul.
> 
> Kirill
> 
Kirill

If someone assigns a rss_limit of 1 byte and sees a usage of 1 page,
won't that be confusing. But having said that it's not a big
change, it should be easy to accommodate.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
