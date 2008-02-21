Return-Path: <linux-kernel-owner+w=401wt.eu-S935620AbYBUWq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935620AbYBUWq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758690AbYBUWqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:46:50 -0500
Received: from smtp5.freeserve.com ([193.252.22.159]:58105 "EHLO
	smtp5.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbYBUWqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:46:47 -0500
X-ME-UUID: 20080221224640848.CF14F1C00083@mwinf3428.me.freeserve.com
Subject: Re: [Rt2400-devel] 2.6.25-rc2 regression in rt61pci wireless driver
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>, chris2553@googlemail.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net
In-Reply-To: <200802212251.26897.IvDoorn@gmail.com>
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <1203542195.3240.1.camel@boulder.homenet>
	 <1203628049.3277.6.camel@boulder.homenet>
	 <200802212251.26897.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 22:46:31 +0000
Message-Id: <1203633991.3186.2.camel@boulder.homenet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 22:51 +0100, Ivo van Doorn wrote:
> On Thursday 21 February 2008, Chris Vine wrote:
[snip] 
> > Here's some further information.
> > 
> > I have a fully functioning version of rt2x00-2.0.14 and mac80211 from
> > wireless-2.6/compat-wireless-2.6 of mid January which works fine on
> > kernel 2.6.24.  On doing a comparison with the rt2x00 in vanilla kernel
> > 2.6.25-rc2, there are no material differences.  (There was a slight
> > change in the declaration a variable in rt2x00usb.c but it is
> > immaterial.)
> > 
> > I compiled up the working mid-January version of rt2x00 and mac80211
> > under kernel 2.6.25-rc2 and I get exactly the same result as I reported
> > earlier, namely I get a kernel panic as soon as I try to associate.  It
> > looks therefore as if something has changed within the remainder of the
> > kernel which has caused rt2x00 (and possibly mac80211?) to break.
> > 
> > This probably explains the problem another user reported with rt61.
> 
> Perhaps something similar like:
> http://bugzilla.kernel.org/show_bug.cgi?id=10058
> in there a reference is made to the following patch:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/broken-out/revert-send-a-single-notification-on-device-state-changes.patch
> 
> Does applying that help?

Yes, well done.

I have spent 20 minutes testing it and it seems to work fine (at least
as well as 2.0.14 does under kernel 2.6.24).  The rate control algorithm
seems to work better as well, but that is probably a mac80211 thing.

Chris


