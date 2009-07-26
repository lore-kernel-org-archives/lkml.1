Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbZGZO5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbZGZO5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 10:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZGZO5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 10:57:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43429 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbZGZO5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 10:57:14 -0400
Message-ID: <4A6C6F96.2050207@redhat.com>
Date: Sun, 26 Jul 2009 18:00:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Chris Mason <chris.mason@oracle.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, dave.mccracken@oracle.com,
       Marcelo Tosatti <mtosatti@redhat.com>, sunil.mushran@oracle.com,
       Schwidefsky <schwidefsky@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
References: <a09e4489-a755-46e7-a569-a0751e0fc39f@default> <4A5A1A51.2080301@redhat.com> <4A5A3AC1.5080800@codemonkey.ws> <20090713201745.GA3783@think> <4A5B9B55.6000404@codemonkey.ws> <20090713210112.GC3783@think> <4A5BA451.5070604@codemonkey.ws>
In-Reply-To: <4A5BA451.5070604@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2009 12:17 AM, Anthony Liguori wrote:
> Chris Mason wrote:
>> On Mon, Jul 13, 2009 at 03:38:45PM -0500, Anthony Liguori wrote:
>>   I'll definitely grant that caching with writethough adds more caching,
>> but it does need trim support before it is similar to tmem.
>
> I think trim is somewhat orthogonal but even if you do need it, the 
> nice thing about implementing ATA trim support verses a 
> paravirtualization is that it works with a wide variety of guests.
>
> From the perspective of the VMM, it seems like a good thing.

trim is also lovely in that images will no longer grow monotonously even 
though guest disk usage is constant or is even reduced.

-- 
error compiling committee.c: too many arguments to function

