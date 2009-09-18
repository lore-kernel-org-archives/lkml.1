Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZIRPJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZIRPJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZIRPJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:09:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42862 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbZIRPJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:09:11 -0400
Date: Fri, 18 Sep 2009 08:05:41 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied
	(Was: Re: [PATCH] Remove broken by design and by implementation
	devtmpfs maintenance disaster)
Message-ID: <20090918150541.GB9307@kroah.com>
References: <20090917125759.GA4045@kroah.com> <m1ab0tcwep.fsf@fess.ebiederm.org> <20090917185306.GA28635@elte.hu> <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com> <alpine.LFD.2.01.0909171322210.4950@localhost.localdomain> <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com> <alpine.LFD.2.01.0909171709410.4950@localhost.localdomain> <1253238637.4071.10.camel@yio.site> <20090918060210.GC7104@kroah.com> <alpine.LFD.2.01.0909180717380.4950@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909180717380.4950@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 07:18:54AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 17 Sep 2009, Greg KH wrote:
> > 
> > I think the udev version in older Fedora releases can't handle this
> > kernel option, which is fine, just don't enable it.  Newer versions can
> > handle it, right?
> 
> .. conversely, if you can't be bothered to set up /dev/null and /dev/zero 
> correctly, I would suggest that you not set them up AT ALL in devtmpfs.

Fair enough.

> The thing is, 0600 for those nodes is just _wrong_. Don't do it.

Ok, Kay, care to just treat these as "special"?

thanks,

greg k-h
