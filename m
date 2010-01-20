Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173Ab0ATTmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0ATTmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089Ab0ATTmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:42:06 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:44453 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753082Ab0ATTmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:42:01 -0500
Date: Wed, 20 Jan 2010 14:42:01 -0500
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       linux-usb@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: Strange EHCI/OHCI IRQ and other PCI errors on boot with 2.6.32
	(which 2.6.26 did not see) on Geode LX/CS5536.
Message-ID: <20100120194201.GN24305@caffeine.csclub.uwaterloo.ca>
References: <20100120154005.GB24307@caffeine.csclub.uwaterloo.ca> <Pine.LNX.4.44L0.1001201134270.1672-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1001201134270.1672-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 11:37:07AM -0500, Alan Stern wrote:
> It's true that the USB controllers appear to be the only devices using
> IRQ 5.  But your startup log shows that only two of the three
> controllers have an associated driver.  Maybe the third controller is
> generating the unwanted interrupts?

Could be.  But I never saw the problem with 2.6.26.  That's puzzling me.

Now I think the 3rd controller may be a client mode interface on the
Geode LX, which I certainly don't use if it has such a thing.

I know what EHCI and OHCI mean.  I don't know what UDC is.  I see mention
of UDC under USB gadget support.  I will try enabling that driver and
see what it does.

-- 
Len Sorensen
