Return-Path: <linux-kernel-owner+w=401wt.eu-S1765924AbYA2TYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765924AbYA2TYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYA2TYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:24:06 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38855 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbYA2TYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:24:04 -0500
Message-ID: <479F7AD8.5050707@cs.wisc.edu>
Date: Tue, 29 Jan 2008 13:13:28 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Konrad Rzeszutek <konrad@darnok.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com, dwm@enoyolf.org, darnok@68k.org, pjones@redhat.com,
       konradr@redhat.com, konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com,
       hpa@zytor.com, lenb@kernel.org, mike.anderson@us.ibm.com,
       dwm@austin.ibm.com, arjan@infradead.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.5)
References: <20080125220629.GA25325@andromeda.dapyr.net> <20080126220123.d20dd393.akpm@linux-foundation.org> <200801281404.54155.konrad@darnok.org>
In-Reply-To: <200801281404.54155.konrad@darnok.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek wrote:
> On Sunday 27 January 2008 01:01:23 you wrote:
>>> On Fri, 25 Jan 2008 18:06:29 -0400 Konrad Rzeszutek <konrad@darnok.org>
>>> wrote: Hey Andrew,
>>>
>>> Please add this patch along with Greg KH's kobject fixes.
>> erm, OK.  But I don't think I'm the appropriate conduit for iscsi paches.
>>
>> By what path _does_ iscsi ode get into the tree, anyway?  Mike is listed as
>> maintainer...
> 
> This is a bit tricky b/c this goes to the drivers/firmware and also depends on 
> the kobject changes in Greg KH tree. But I should have included Mike on the 
> CC which I keep on forgetting <sigh>.
> 

It is probably better if it goes through Greg or Andrew. It will not 
conflict with any iscsi patches. It looks like it is heavier on kobject 
and sysfs and has some acpi digging magic, and almost no iscsi stuff in 
there.
