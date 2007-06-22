Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbXFVHun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbXFVHun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbXFVHug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:50:36 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:8741 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbXFVHuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:50:35 -0400
Message-ID: <467B2F4F.2030101@openvz.org>
Date: Fri, 22 Jun 2007 06:09:19 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, Andrew Morton <akpm@osdl.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch -rss] Make RSS accounting display more user friendly
References: <20070620154655.13844.42876.sendpatchset@balbir-laptop> <6599ad830706211217l65d76d4ehb42f9165bcf45dd@mail.gmail.com>
In-Reply-To: <6599ad830706211217l65d76d4ehb42f9165bcf45dd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 6/20/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>
>>
>> Display the current usage and limit in a more user friendly manner.
>> Number
>> of pages can be confusing if the page size is different. Some systems
>> can choose a page size of 64KB.
> 
> I'm not sure that's such a great idea. "Human-friendly"
> representations would make programmatic parsing harder.
> 
> What's wrong with just showing counts in bytes in the control files?

Nothing wrong, but currently they are shown in "natural" points, i.e. in
those that the controller accounts them in. For RSS controller the natural
point is "page", but auto-converting them from pages to bytes is wrong, as
not all the controllers account in pages. I think that the better way is 
to show the value in the internal units and specify (somehow) what these 
units are. The userspace then can read them and convert accordingly.

> Paul

Thanks,
Pavel
