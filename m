Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZAIIVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZAIIVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 03:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZAIIVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 03:21:15 -0500
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:32914 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbZAIIVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 03:21:14 -0500
Message-ID: <37611.166.70.238.44.1231486566.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20090109064658.GG5038@1wt.eu>
References: <40416.166.70.238.44.1231467823.squirrel@webmail.wolfmountaingroup.com>
    <20090109064658.GG5038@1wt.eu>
Date: Fri, 9 Jan 2009 00:36:06 -0700 (MST)
Subject: Re: [ANNOUNCE] Kernel Blocking Firewall
From: jmerkey@wolfmountaingroup.com
To: "Willy Tarreau" <w@1wt.eu>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jan 08, 2009 at 07:23:43PM -0700, jmerkey@wolfmountaingroup.com
> wrote:
>> iptables is just too cumbersome and memory comsumptive to work well and
>> has a shitty app inteface so I wrote one with a kernel level database
>> and
>> combined it with postfix.    This firewall actually drops packets on the
>> floor by port, or in their entirety by IP address to deal with these
>> jerks.
>>
>> The code is a kernel module that will build an RBL database to disk and
>> it
>> will cache up to 500,000 IP addresses efficiently on a 1GB home personal
>> computer.  The more memory you have, the more IP addresses you can
>> cache.
>> It is configurable and possible to hold millions of them if you have 4GB
>> of memory in the server.
>
> why didn't you use ipset for that ? It's designed exactly for this usage
> and is a lot easier to use than plain iptables for dynamic filtering.
>
> Willy


No database to store the 500,000+ addresses you will harvest in about 2
months, that's why.  The one I did uses an lru cached database that runs
in the kernel, and not userspace, so you can filer real time, and manage
the database real time.

Jeff
>
>


