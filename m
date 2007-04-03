Return-Path: <linux-kernel-owner+w=401wt.eu-S1945959AbXDCV1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945959AbXDCV1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945966AbXDCV1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:27:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945959AbXDCV1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:27:06 -0400
Message-ID: <4612C6A6.9020003@redhat.com>
Date: Tue, 03 Apr 2007 17:27:02 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mbind and alignment
References: <20070402204202.GC3316@interface.famille.thibault.fr>
In-Reply-To: <20070402204202.GC3316@interface.famille.thibault.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault wrote:
> Hi,
> 
> mbind(start, len, ...) currently requires that "start" be page-aligned,
> but not "len" (which automatically gets page-rounded up).  This is a bit
> odd:
> 
> - the userland type of start is void*, which people would expect to be a
>   pointer to some variable.
> - start needing to be page-aligned but len not needing to is not very
>   consistent.
> - none of this is documented in the manual page dated 2006-02-07
> 
> So one of those should probably be done to free people from headaches:
> 
> - document "start" requirement in the manual page
> - require len to be aligned too, and document the requirements in the
>   manual page
> - drop the "start" requirement and just round down the page + adjust
>   size automatically.
> 

Want to help with man page maintenance?  Grab the latest tarball at
ftp://ftp.win.tue.nl/pub/linux-local/manpages/,
read the HOWTOHELP file and grep the source files for 'FIXME'.

