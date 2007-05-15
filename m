Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbXEOSiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbXEOSiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 14:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbXEOSiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 14:38:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094AbXEOSiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 14:38:14 -0400
Message-ID: <4649FDEA.2050703@redhat.com>
Date: Tue, 15 May 2007 14:37:30 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Folkert van Heusden <folkert@vanheusden.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.21.1] OOPS in timer stats code
References: <3644.62.177.207.163.1179227559.squirrel@klant.bhosted.nl> <6bffcb0e0705150433o95c801eo4818a9f36e5bb770@mail.gmail.com>
In-Reply-To: <6bffcb0e0705150433o95c801eo4818a9f36e5bb770@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> [Adding Thomas to CC]
> 
> On 15/05/07, Folkert van Heusden <folkert@vanheusden.com> wrote:
>> Hi,
>>
>> After an uptime of, say, 4 hours I got an oops on my P4 with HT and
>> 2GB ram.
>> It has dynamic ticks enabled as well has timer stats. I cannot reboot the
>> machine to give more details right now (19:00 gmt+1 i can).
>>
>> For now, this is the oops:
>>
>> [13092.479019] BUG: unable to handle kernel paging request at virtual
>> address b9d0458f

Timer hash list contains a user address.
