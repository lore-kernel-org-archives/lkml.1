Return-Path: <linux-kernel-owner+w=401wt.eu-S1765668AbXIMVmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765668AbXIMVmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbXIMVmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:42:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60949 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755872AbXIMVmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:42:38 -0400
Date: Thu, 13 Sep 2007 14:42:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Dan Aloni <da-x@monatomic.org>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH] Add ELF note with Linux version
Message-Id: <20070913144228.2efcd5d9.akpm@linux-foundation.org>
In-Reply-To: <46DFD825.2020109@goop.org>
References: <20070904150018.GA4357@suse.de>
	<46DFD825.2020109@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Sep 2007 11:36:21 +0100
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Bernhard Walle wrote:
> > This patch adds version information to the ELF kernel file. Together
> > with the bzImage version information, this allows distributions to
> > identify the kernel version based on the file name.
> >   
> 
> Seems reasonable to me, but I think the macro could be just called
> "ELFNOTE".
> 

You removed Bernhard from the cc list.

I'd like to know a little bit more about why this is needed, how it will be
used, etc.  And given that this feature is intended to improve life for
distributors, it would be nice to get some feedback from the appropriate
persons.

So could you please redo the patch as Jermey suggests (if you agree),
revamp the description and then cc suitable people at suitable distros so
we can get their input?

Thanks.
