Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbZJJFu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbZJJFu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 01:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZJJFu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 01:50:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:15838 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbZJJFu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 01:50:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,536,1249282800"; 
   d="scan'208";a="734974419"
Subject: Re: [PATCH 0/9] Add vsprintf extension %pU to print UUID/GUIDs and
 use it
From: Huang Ying <ying.huang@intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Joe Perches <joe@perches.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Adrian Hunter <adrian.hunter@nokia.com>, Alex Elder <aelder@sgi.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@lst.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
       Matt Mackall <mpm@selenic.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Neil Brown <neilb@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>,
       Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>
In-Reply-To: <200910010207.45514.laurent.pinchart@ideasonboard.com>
References: <cover.1254193019.git.joe@perches.com>
	 <1254203852.15717.1506.camel@yhuang-dev.sh.intel.com>
	 <200910010207.45514.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain
Date: Sat, 10 Oct 2009 13:50:17 +0800
Message-Id: <1255153817.6047.1.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 08:07 +0800, Laurent Pinchart wrote: 
> On Tuesday 29 September 2009 07:57:32 Huang Ying wrote:
> > Hi, Joe,
> > 
> > Thanks for the patch. I think that is a good idea.
> > 
> > For your patch. I think you need a changelog for each patch.
> > 
> > It seems that the binary representation of UUID can be little-endian
> > (used by most kernel components) or big-endian (defined by RFC4122, used
> > in network?). Maybe we should consider about that.
> 
> I think that's what the 'r' option is supposed to handle. Maybe you could use 
> 'b' and 'l' options instead, to specify the endianness explicitly.

Yes. Thanks for you reminding.

> > In fact, I find there are many different UUID/GUID definitions in
> > kernel, such as that in efi, many file systems, some drivers, etc. It
> > seems that every kernel components need UUID/GUID has its own
> > definition, so I think we should unify all the UUID/GUID definitions in
> > kernel too. The file attached is a draft unified UUID/GUID definition,
> > with byte-order issue in mind.
> > 
> > Any comment?
> 
> Not much, it would help if you could show where those functions would be used.
> 
> I would also use the 'le' and 'be' prefixes (as in le16, be32) instead of 'l' 
> and 'b', making it leuuid and beuuid, or maybe uuid_le and uuid_be.

Yes. It seems 'be' and 'le' is better than 'b' an 'l'.

Best Regards,
Huang Ying

