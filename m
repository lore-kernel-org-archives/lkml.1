Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYFUBDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYFUBDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 21:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYFUBDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 21:03:34 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:50450
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbYFUBDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 21:03:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugAAGDwW0h8qNQu/2dsb2JhbAAIr3o
X-IronPort-AV: E=Sophos;i="4.27,682,1204470000"; 
   d="scan'208";a="279801525"
Subject: Re: [RFC PATCHES] Re: Is configfs the right solution for
	configuration based fs?
From: Ben Nizette <bn@niasdigital.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>, Felix Fietkau <nbd@openwrt.org>,
       Al Viro <viro@ftp.linux.org.uk>, "H. Peter Anvin" <hpa@kernel.org>
In-Reply-To: <20080620213708.GC21416@mail.oracle.com>
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com>
	 <1213002187.698.62.camel@johannes.berg>
	 <1213056772.4089.42.camel@moss.renham>
	 <20080619024804.GA29765@mail.oracle.com>
	 <1213942750.2336.43.camel@moss.renham>
	 <20080620065253.GA14238@ca-server1.us.oracle.com>
	 <1213953776.2336.75.camel@moss.renham>
	 <20080620213708.GC21416@mail.oracle.com>
Content-Type: text/plain
Organization: Nias Digital
Date: Sat, 21 Jun 2008 11:03:49 +1000
Message-Id: <1214010229.2336.88.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-06-20 at 14:37 -0700, Joel Becker wrote:
> On Fri, Jun 20, 2008 at 07:22:56PM +1000, Ben Nizette wrote:
> > A version of my gpio-dev interface is attached.  Bear in mind it was
> > never completed, it's full of known bugs but hey, might be useful for
> > you anyway :-)
> 
> 	Looks good.  Fits about what I would expect a configfs interface
> to look like, with simple show/store stuff.  I can see where some macros
> would have shortened some bolierplate.
> 	Was there any other boilerplate you found cumbersome?  I mean
> outside of defining attribute structs and the show/store_attr()
> trampoline functions?  Let me know, so I can incorporate it.
> 

You know, I think you've about covered the boilerplate work.  Apart from
that, well it took me a millisecond to work out what the point of
config_{group,item}s was; I went in kinda expecting to see one struct
for directories and one for attributes.  In fact I still not sure I can
explain the need for config_items separate from config_groups.  Little
help?  :-)

	--Ben.

> Joel
> 
