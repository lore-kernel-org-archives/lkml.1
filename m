Return-Path: <linux-kernel-owner+w=401wt.eu-S933661AbYA2Uiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661AbYA2Uiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbYA2Uim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:38:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57137 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbYA2Uil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:38:41 -0500
Date: Tue, 29 Jan 2008 11:44:59 -0800
From: Greg KH <greg@kroah.com>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Konrad Rzeszutek <konrad@darnok.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dwm@enoyolf.org, darnok@68k.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com,
       arjan@infradead.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.5)
Message-ID: <20080129194459.GB5926@kroah.com>
References: <20080125220629.GA25325@andromeda.dapyr.net> <20080126220123.d20dd393.akpm@linux-foundation.org> <200801281404.54155.konrad@darnok.org> <479F7AD8.5050707@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479F7AD8.5050707@cs.wisc.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 01:13:28PM -0600, Mike Christie wrote:
> Konrad Rzeszutek wrote:
>> On Sunday 27 January 2008 01:01:23 you wrote:
>>>> On Fri, 25 Jan 2008 18:06:29 -0400 Konrad Rzeszutek <konrad@darnok.org>
>>>> wrote: Hey Andrew,
>>>>
>>>> Please add this patch along with Greg KH's kobject fixes.
>>> erm, OK.  But I don't think I'm the appropriate conduit for iscsi paches.
>>>
>>> By what path _does_ iscsi ode get into the tree, anyway?  Mike is listed 
>>> as
>>> maintainer...
>> This is a bit tricky b/c this goes to the drivers/firmware and also 
>> depends on the kobject changes in Greg KH tree. But I should have included 
>> Mike on the CC which I keep on forgetting <sigh>.
>
> It is probably better if it goes through Greg or Andrew. It will not 
> conflict with any iscsi patches. It looks like it is heavier on kobject and 
> sysfs and has some acpi digging magic, and almost no iscsi stuff in there.

It does not need to go through me as all of the kobject changes it
depended on are now in Linus's tree.

thanks,

greg k-h
