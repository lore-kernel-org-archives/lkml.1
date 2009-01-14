Return-Path: <linux-kernel-owner+w=401wt.eu-S1760417AbZANKU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417AbZANKU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbZANKTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:19:37 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:37155 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbZANKTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:19:36 -0500
Date: Wed, 14 Jan 2009 11:18:51 +0100
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: David Miller <davem@davemloft.net>
Cc: "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "tj@kernel.org" <tj@kernel.org>, "gregkh@suse.de" <gregkh@suse.de>,
       "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "hinko.kocevar@cetrtapot.si" <hinko.kocevar@cetrtapot.si>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
Message-ID: <20090114101851.GE19262@axis.com>
References: <20090113.131030.207355839.davem@davemloft.net> <20090113221235.GD19262@axis.com> <2f11576a0901131440w7fd3290uc9664aaf7aa89b08@mail.gmail.com> <20090113.144521.97357573.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113.144521.97357573.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 11:45:21PM +0100, David Miller wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Wed, 14 Jan 2009 07:40:19 +0900
> 
> > > It may be that we've worked around the other spots, although I haven't
> > > seen anything like that, we might just have been lucky until now.
> > >
> > > Can you recall another place where this trick is used?
> > 
> > rmap.
> > Don't CRIS use mmu?
> 
> I'm beginning to suspect the issue is only with objects
> in the kernel image itself.  Dynamically allocated memory
> is properly aligned and therefore the "low bit status bits
> in pointer" trick works.

Yes, that agrees with what I see here, and why we haven't seen this
problem more often.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
