Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbZFDQkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbZFDQkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZFDQkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:40:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50123 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbZFDQkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:40:02 -0400
Subject: Re: [dm-devel] Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft 
 RAID under Linux
From: Heinz Mauelshagen <heinzm@redhat.com>
Reply-To: heinzm@redhat.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Ed Ciechanowski <ed.ciechanowski@intel.com>,
       Jacek Danecki <jacek.danecki@intel.com>
In-Reply-To: <e9c3a7c20906031026s49a5a694hb91db40dc05a2580@mail.gmail.com>
References: <18980.48553.328662.80987@notabene.brown>
	 <4A25876A.1010901@garzik.org> <18981.62579.171350.910761@notabene.brown>
	 <1244040123.6938.19.camel@o>
	 <e9c3a7c20906031026s49a5a694hb91db40dc05a2580@mail.gmail.com>
Content-Type: text/plain
Organization: Red Hat GmbH
Date: Thu, 04 Jun 2009 18:38:56 +0200
Message-Id: <1244133536.5541.48.camel@o>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-03 at 10:26 -0700, Dan Williams wrote:
> On Wed, Jun 3, 2009 at 7:42 AM, Heinz Mauelshagen <heinzm@redhat.com> wrote:
> > On Wed, 2009-06-03 at 13:56 +1000, Neil Brown wrote:
> >> As for integrating the two code bases.... people have been suggesting
> >> that for years, but I suspect few of them have looked deeply at the
> >> practicalities.  Apparently it was suggested at the recent "storage
> >> summit".  However as the primary md and dm developers were absent, I
> >> have doubts about how truly well-informed that conversation could have
> >> been.
> >
> > Agreed, we'd need face-time and talk issues through in order to come up
> > with any such plan for md+dm integration.
> >
> 
> What are your general impressions of dmraid using md kernel
> infrastructure for raid level support?

At the time of the dmraid project start, we already had libdevmapper
which was suitable to handle in-kernel device manipulation with no
adequate on the MD side so it was the appropriate interface to use.

Cheers,
Heinz

> 
> Thanks,
> Dan

