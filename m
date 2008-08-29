Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbYH2Ub6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbYH2Ub6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 16:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYH2Ubt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 16:31:49 -0400
Received: from senator.holtmann.net ([87.106.208.187]:47091 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbYH2Ubs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 16:31:48 -0400
Subject: Re: USBIP protocol
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       bgmerrell@novell.com, hirofuchi@users.sourceforge.net,
       linux-kernel@vger.kernel.org, usbip-devel@lists.sourceforge.net
In-Reply-To: <87ej47q5k8.fsf@basil.nowhere.org>
References: <20080829140224.GC1968@parisc-linux.org>
	 <87ej47q5k8.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Sat, 30 Aug 2008 00:31:43 +0200
Message-Id: <1220049103.7145.23.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

> > I'm in the middle of implementing a userspace client for usbip and I
> > strongly feel that the protocol needs to be changed before it is merged.
> >
> >  - I'm unconvinced that TCP is the correct protocol to be running this over.
> >    I understand the reluctance to use UDP, but the protocol is fundamentally
> >    packet-based.  If TCP is used, the delimitation of packets within the
> >    stream needs to be much more robust. 
> 
> If you want reliable transport with record boundaries an alternative
> would be also SCTP. Main drawback is that firewalls often don't support it
> though (but presumably that wouldn't be a big issue for this)

I would also have proposed SCTP. The telco carries seems be very happy
with it.

Regards

Marcel


