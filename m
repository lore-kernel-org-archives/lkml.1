Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab0CFJEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 04:04:33 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:34782 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab0CFJER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 04:04:17 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: commit 554f76962d3a6eb5110415f1591aca83f96a84ae hangs USB for vmware 7.0.1
Date: Sat, 6 Mar 2010 10:03:50 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Chua <jeff.tw.chua@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, petr@vmware.com,
       Eli Collins <ecollins@vmware.com>
References: <Pine.LNX.4.64.1003060606480.6040@boston.corp.fedex.com> <alpine.LFD.2.00.1003051438280.3906@localhost.localdomain> <b6a2187b1003052122w105851abhd54a32f77aef22c4@mail.gmail.com>
In-Reply-To: <b6a2187b1003052122w105851abhd54a32f77aef22c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003061003.50671.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 6. März 2010 06:22:48 schrieb Jeff Chua:
> It seems to hang trying to read from /proc/bus/usb/devices.
> 
> So, next I just try to "cat /proc/bus/usb/devices" and it hangs as well.
> 
> Reverting the commit makes "cat /proc/bus/usb/devices" works again.
> 
> Does this happen to me only?

As far as I can tell, yes. I cannot replicate it.

Please get me at least a sysrq-T trace.
There's no obvious place usb_device_read() takes usbfs_mutex.

	Regards
		Oliver
