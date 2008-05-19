Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbYESP6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbYESP6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYESP54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:57:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbYESP5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:57:54 -0400
Subject: Re: [RFC] make wext wireless bits optional and deprecate them
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>, netdev <netdev@vger.kernel.org>,
       Jean Tourrilhes <jt@hpl.hp.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1211211547.6252.54.camel@johannes.berg>
References: <1211026337.3827.25.camel@johannes.berg>
	 <CD993362-B1DE-4E4D-8A5B-E9E2AD7DA04C@holtmann.org>
	 (sfid-20080517_154639_384202_6D3479C2)  <1211032475.6252.2.camel@johannes.berg>
	 <1211117795.686.15.camel@localhost.localdomain>
	 <1211199368.6252.19.camel@johannes.berg>
	 <1211210686.12187.6.camel@localhost.localdomain>
	 <1211211547.6252.54.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 19 May 2008 11:53:58 -0400
Message-Id: <1211212438.12187.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 17:39 +0200, Johannes Berg wrote:
> On Mon, 2008-05-19 at 11:24 -0400, Dan Williams wrote:
> > On Mon, 2008-05-19 at 14:16 +0200, Johannes Berg wrote:
> > > > Instead of testing for wireless/, best thing would probably be to call
> > > > SIOCGIWRANGE on the device and if it returns EOPNOTSUP then it's not
> > > > wireless.  Some drivers may have to load firmware to figure out
> > > > supported rates and encryption capabilities, but to be honest, NM does
> > > > this to detect wireless devices and I haven't run into any issues in 4
> > > > years using it.  If there are issues with drivers, then we need to fix
> > > > the driver too.
> > > 
> > > I was about to propose calling SIOCGIWNAME since that is what
> > > wireless-tools do and that linux/wireless.h indicates.
> > 
> > Hmm; NAME is pretty useless.  That's fine to do, I guess WEXT requires
> > that NAME return _something_ at least.  NAME should never ever be used
> > for anything more, but since wireless-tools appears to do this that's
> > fine.
> 
> Yes, I realise it is completely useless, but wext seems to require that
> it be implemented. RANGE would work as well but typically has much more
> complexity in the kernel.

Yup; NAME's better for this even though it's useless.

Dan

