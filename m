Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZICPLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZICPLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 11:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbZICPLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 11:11:51 -0400
Received: from c60.cesmail.net ([216.154.195.49]:4369 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319AbZICPLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 11:11:49 -0400
Subject: Re: [PATCH] rt2x00: Get rid of duplicate usb id from rt2500usb
From: Pavel Roskin <proski@gnu.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Amit Kucheria <amit.kucheria@canonical.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <a32f33a40909030718v494f8fech6ba3c854b5c84ef8@mail.gmail.com>
References: <1251978140-4992-1-git-send-email-amit.kucheria@canonical.com>
	 <20090903115521.GB12597@tuxdriver.com>
	 <a32f33a40909030718v494f8fech6ba3c854b5c84ef8@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 11:11:39 -0400
Message-Id: <1251990699.6521.12.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 16:18 +0200, Ivo Van Doorn wrote:
> On Thu, Sep 3, 2009 at 1:55 PM, John W. Linville<linville@tuxdriver.com> wrote:
> > On Thu, Sep 03, 2009 at 02:42:20PM +0300, Amit Kucheria wrote:
> >> USB_DEVICE(0x148f, 0x2573) is served by the rt73usb driver where it is already
> >> defined. Remove it from rt2500usb.
> >>
> >> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> >> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> >
> > IIRC there are IDs that are used by different devices where rt73usb
> > covers one device and the rt2500usb covers another.  Are you sure
> > this is not one of those?
> 
> Yes, I believe this particular ID was already discussed some time ago
> on this list. This is one of the infamous duplicate IDs. (Fortunately not
> one of those infamous Linksys devices with 5 different chipsets for the
> same ID).

The famous Linksys devices can be distinguished by the textual PCMCIA
ID.  In this case, there is no reliable way to distinguish the devices
without trying the drivers.  I tried and could not find any difference
between "lsusb -v" output for the devices said to be supported by
rt2500usb and rt73usb.

-- 
Regards,
Pavel Roskin
