Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZJAAGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZJAAGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 20:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbZJAAGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 20:06:00 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:41831 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbZJAAF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 20:05:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 0/9] Add vsprintf extension %pU to print UUID/GUIDs and use it
Date: Thu, 1 Oct 2009 02:07:45 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1; KDE/4.3.1; x86_64; ; )
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
References: <cover.1254193019.git.joe@perches.com> <1254203852.15717.1506.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1254203852.15717.1506.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910010207.45514.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 September 2009 07:57:32 Huang Ying wrote:
> Hi, Joe,
> 
> Thanks for the patch. I think that is a good idea.
> 
> For your patch. I think you need a changelog for each patch.
> 
> It seems that the binary representation of UUID can be little-endian
> (used by most kernel components) or big-endian (defined by RFC4122, used
> in network?). Maybe we should consider about that.

I think that's what the 'r' option is supposed to handle. Maybe you could use 
'b' and 'l' options instead, to specify the endianness explicitly.

> In fact, I find there are many different UUID/GUID definitions in
> kernel, such as that in efi, many file systems, some drivers, etc. It
> seems that every kernel components need UUID/GUID has its own
> definition, so I think we should unify all the UUID/GUID definitions in
> kernel too. The file attached is a draft unified UUID/GUID definition,
> with byte-order issue in mind.
> 
> Any comment?

Not much, it would help if you could show where those functions would be used.

I would also use the 'le' and 'be' prefixes (as in le16, be32) instead of 'l' 
and 'b', making it leuuid and beuuid, or maybe uuid_le and uuid_be.

-- 
Regards,

Laurent Pinchart
