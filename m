Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbYHES5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbYHES5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759315AbYHESzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:55:11 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35734 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757326AbYHESzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:55:10 -0400
Date: Tue, 5 Aug 2008 14:54:38 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
Message-ID: <20080805185438.GA8453@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Press, Jonathan" <Jonathan.Press@ca.com>, Greg KH <greg@kroah.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
	malware-list@lists.printk.net,
	linux-security-module@vger.kernel.org
References: <20080805103840.1aaa64a5@infradead.org> <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805181141.GA10700@kroah.com> <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 02:38:23PM -0400, Press, Jonathan wrote:
> Is your point that Linux and Unix machines are less vulnerable to
> viruses?  If so, that's not relevant to my point at all.  A Unix machine
> can be a carrier, passing infections on to other vulnerable platforms
> (guess which one).  An enterprise security system sees the entire
> enterprise as an integrated whole -- not just individual machines with
> their own separate attributes and no impact on each other at all.

Sure, but if that's the case, you don't need to have a blocking open()
interface.  Having inotify tell your application that a file
descriptor that had been opened for writing has been closed
(IN_CLOSE_WRITE) should be quite sufficient.

						- Ted
