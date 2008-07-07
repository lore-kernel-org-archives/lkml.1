Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYGGKDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYGGKDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 06:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYGGKDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 06:03:40 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:36102 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYGGKDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 06:03:39 -0400
Message-ID: <4871E9F0.60608@csr.com>
Date: Mon, 07 Jul 2008 11:03:28 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Dropping WUSB/UWB from my patch queue
References: <20080630180009.GA30833@kroah.com>
In-Reply-To: <20080630180009.GA30833@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jul 2008 10:03:28.0764 (UTC) FILETIME=[B43AABC0:01C8E018]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Hi David,
> 
> In looking further at the WUSB/UWB code, it doesn't look like it is
> going to make it for the 2.6.27 kernel tree due to the reliance on some
> contriversial core USB changes as well as a total lack of documentation
> for the sysfs apis.

I assume you are referring to the usb_dev_reset_delayed() change here.
This is only required by the wire adapter code and should not prevent
the majority of the UWB and WUSB stack from being merged.

You should postpone:

usb-add-usb_dev_reset_delayed.patch
wusb-add-the-wire-adapter-core.patch
wusb-add-hwa-hc-wireless-host-controller-driver.patch
wusb-wa-abort-rpipe-request-type-fix.patch

I will correct the lack of sysfs API documentation this week.  Please
advise on where the documentation should go and its style and format.
Be aware that some of the API is experimental and subject to change. I
will ensure the documentation is clear on this and that the Kconfig
entries depend on EXPERIMENTAL.

Would this be sufficient to reinstate the majority of the UWB and WUSB
stacks for 2.6.27?

> Because of this, I've dropped all of the patches from my USB queue, so
> they will no longer show up in the -next releases anymore.

In future, it would be appreciated if any issues with UWB patches are
discussed rather than summarily dropping them.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
