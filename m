Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbZCTJYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbZCTJYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 05:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbZCTJYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 05:24:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:32424 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZCTJYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 05:24:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eZEE6WRXn7gpcigsopz0sEacbyHbkuAWiz7HbIla6FsWxBEmyrLqDoOO4Za16zldsR
         u0zAPhxylaUACfWQvwBgjhJ79ofMIg1G5oixVyPyhpCYpkhBlBzZe3qeHI0a2qYEbgC2
         qu9O2u0lklZemOoXggvg2KCRUuy90cRSP5Xaw=
Date: Fri, 20 Mar 2009 02:24:21 -0700
From: Shentino <shentino@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shentino <shentino@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: question about pt locking
Message-ID: <20090320092421.GA7195@shentino-desktop>
References: <20090320081633.GA673@shentino-desktop> <1237539130.24626.43.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237539130.24626.43.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 09:52:10AM +0100, Peter Zijlstra wrote:
> On Fri, 2009-03-20 at 01:16 -0700, Shentino wrote:
> > Just curious, but does a process effectively have a read-lock on its 
> > page tables when it's in userland?
> 
> No, page reclaim can fiddle with a running process' page tables
> concurrently.

Yeah just now remembered why the kernel has tlb inval/flush routines

...duh...

Thanks for the answers though, I learned something today.
