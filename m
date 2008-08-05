Return-Path: <linux-kernel-owner+w=401wt.eu-S1763189AbYHERJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763189AbYHERJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760994AbYHERJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:09:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44189 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760687AbYHERJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:09:05 -0400
Date: Tue, 5 Aug 2008 10:04:57 -0700
From: Greg KH <greg@kroah.com>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Eric Paris <eparis@redhat.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
Message-ID: <20080805170457.GC9639@kroah.com>
References: <1217883616.27684.19.camel@localhost.localdomain> <20080804223249.GA10517@kroah.com> <4898379D.2060709@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4898379D.2060709@aitel.hist.no>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 01:21:01PM +0200, Helge Hafting wrote:
> Greg KH wrote:
>>
>>
>> I don't see anything in the list above that make this a requirement that
>> the code to do this be placed within the kernel.
>>
>> What is wrong with doing it in glibc or some other system-wide library
>> (LD_PRELOAD hooks, etc.)?
>>   
>
> A linux virus would trivially get around that by doing its own syscalls
> instead of using glibc. (It might still link dynamically to glibc so
> you don't get suspicious, but won' actually use it when doing bad stuff.)

That's fine, then the file is corrupted.  It is when the "normal"
program goes to load the file that we want to block and determine if we
have a problem or not in the data.

virus scanners are not a security model in the aspect of SELinux or
SMACK.  If they were, they would just use the LSM interface.  virus
scanners are interested in blocking "normal" programs from reading
invalid data from disk before acting on it or executing it.

thanks,

greg k-h
