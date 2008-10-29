Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbYJ2Pn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbYJ2Pn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYJ2Pnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:43:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:46120 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYJ2Pnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:43:49 -0400
Message-ID: <4908849B.8000408@oracle.com>
Date: Wed, 29 Oct 2008 08:43:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: dedekind@infradead.org
CC: Alexey Dobriyan <adobriyan@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       ericvh@gmail.com, mfasheh@suse.com
Subject: Re: How do I printk <type> correctly?
References: <20081023114133.GA30187@x200.localdomain>	 <20081028161136.c652b9fd.randy.dunlap@oracle.com>	 <1225267204.4350.10.camel@sauron>	 <20081029083403.5afac2c1.randy.dunlap@oracle.com> <1225294610.4350.19.camel@sauron>
In-Reply-To: <1225294610.4350.19.camel@sauron>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> On Wed, 2008-10-29 at 08:34 -0700, Randy Dunlap wrote:
>> It's in the C standard, which we don't try to put into Documentation/ AFAIK.
>>
>> section 6.5.3.4, The sizeof operator:
>>
>> 4 The value of the result is implementation-defined, and its type (an unsigned integer type)
>> is size_t, defined in <stddef.h> (and other headers).
> 
> Well, OK. I was more thinking about printing stuff like ino_t.
> UBIFS used %lu for this which was the source of warnings.

I've been thinking of adding (trying to add) Alexey's hints in the
Doc/ tree in some new file.

-- 
~Randy
