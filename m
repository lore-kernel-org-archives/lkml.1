Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbYJIHCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbYJIHCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 03:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYJIHCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 03:02:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795AbYJIHCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 03:02:44 -0400
Date: Thu, 9 Oct 2008 00:02:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [mmotm 02/Oct] fix buid error of hid-core
Message-Id: <20081009000208.d902be73.akpm@linux-foundation.org>
In-Reply-To: <20081009154404.DED3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081004190725.CE3E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081004190856.CE41.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081009154404.DED3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Oct 2008 15:45:19 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Ping!

I'm in hiding until linux-next comes back.

> > Patch against: mmotm 02 Oct
> > Applied after: usb-usb-remove-warn-macro-from-usbh.patch
> > 
> > fix following buiild error
> > 
> > -------------------------
> >   CC [M]  drivers/hid/usbhid/hid-core.o
> > drivers/hid/usbhid/hid-core.c: In function 'usbhid_submit_report':
> > drivers/hid/usbhid/hid-core.c:417: error: incompatible type for argument 1 of 'dev_driver_string'
> > drivers/hid/usbhid/hid-core.c:417: error: incompatible type for argument 1 of 'dev_name'
> > drivers/hid/usbhid/hid-core.c:436: error: incompatible type for argument 1 of 'dev_driver_string'
> > drivers/hid/usbhid/hid-core.c:436: error: incompatible type for argument 1 of 'dev_name'
> > drivers/hid/usbhid/hid-core.c: In function 'usbhid_init_reports':
> > drivers/hid/usbhid/hid-core.c:568: error: incompatible type for argument 1 of 'dev_driver_string'
> > drivers/hid/usbhid/hid-core.c:568: error: incompatible type for argument 1 of 'dev_name'
> > make[3]: *** [drivers/hid/usbhid/hid-core.o] Error 1
> > make[2]: *** [drivers/hid/usbhid] Error 2
> > make[1]: *** [drivers/hid] Error 2
> > make: *** [drivers] Error 2

Attempting to remove a widely-used macro in a single patch within our
distributed development model was, frankly, short-sighted to the point
of stupidity.  I've had enough of dealing with stuff like this.  If
Stephen wants to take it on then fine.

otoh given that others need to depend on this mess to get work done, I
guess I'm forced to continue to take out the garbage.  Sigh.

