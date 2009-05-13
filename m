Return-Path: <linux-kernel-owner+w=401wt.eu-S1761223AbZEMSyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761223AbZEMSyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 14:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbZEMSx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 14:53:57 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:58954 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbZEMSx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 14:53:56 -0400
Date: Wed, 13 May 2009 19:53:56 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Message-ID: <20090513185356.GA20140@sucs.org>
References: <20090511072135.GA4682@sucs.org> <20090513032053.GA29919@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513032053.GA29919@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the slow reply...

On Tue, May 12, 2009 at 08:20:54PM -0700, Dmitry Torokhov wrote:
> 
> On Mon, May 11, 2009 at 08:21:35AM +0100, Sitsofe Wheeler wrote:
> > 
> > With the latest 2.6.29-rc4 I've been finding that my EeePC 900's
> > trackpad is frequently not detected on boot:

That should have been 2.6.30-rc4...

> > The workaround has been to do the following as root:
> > 
> > echo i8042 > /sys/bus/platform/drivers/i8042/unbind ; echo i8042 > /sys/bus/platform/drivers/i8042/bind
> 
> Does it always discover it after rebind or you need to do that a few

Yes it always discovers it after a rebind (it just happened again now
actually). I never have to do the rebind more than once.

> times? Also, is the touchpad detected reliably if you boot an older
> kernel?

The problem seems to be happening more frequently with the latest 2.6.30
kernel but the problem did happen with older kernels (even with the
kernel that Xandros ship with the EeePC which is 2.6.21 based) but it
was very infrequent (once every fifty boots or so).

> > Having talked to Matthew a few months ago it sounds like the problem is
> > that the something needs to be reset more aggressively at boot. This
> > problem used to happen very rarely (maybe once every 50 or so boots)
> > with older kernels but now seems to be happening every boot.
> > 
> 
> Could you try booting with i8042.debug and send me dmesg of the case

OK I'll add the line and wait for the issue to arise again.

> when touchpad is not detected, please? BTW, why don't you have Elantech
> support enabled?

I am running a distribution (Ubuntu 8.04) with an old Xorg that doesn't
support the Elantech driver of new kernels.

-- 
Sitsofe | http://sucs.org/~sits/
