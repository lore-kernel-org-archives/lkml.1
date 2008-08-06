Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbYHFPjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbYHFPjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759416AbYHFPe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:34:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:56316 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759383AbYHFPeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:34:24 -0400
Date: Wed, 6 Aug 2008 08:24:02 -0700
From: Greg KH <greg@kroah.com>
To: tvrtko.ursulin@sophos.com
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
	interfaceforon access scanning
Message-ID: <20080806152402.GC13996@kroah.com>
References: <20080805181141.GA10700@kroah.com> <20080806092516.814453167F8@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806092516.814453167F8@pmx1.sophos.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 10:24:21AM +0100, tvrtko.ursulin@sophos.com wrote:
> Greg KH wrote on 05/08/2008 19:11:41:
> 
> > On Tue, Aug 05, 2008 at 02:04:26PM -0400, Press, Jonathan wrote:
> > > I'm not sure if this is off the direct idea of this thread, or if I am
> > > possibly missing the whole point.
> > 
> > I think you might be missing the point a bit here, as the traditional
> > Unix model that Linux has prevents much of what the "traditional AV"
> > products need to do, right?
> 
> Could you please explain some more what and how do you think Unix model 
> prevents?

It prevents any user from overwriting an existing executable, and it
prevents any user from adding an executable file to a common directory
(/usr/bin).

It also prevents any user from overwriting a different user's data file.

What specific threat model are you feeling is still present on Linux
today that this proposal is supposed to address?

thanks,

greg k-h
