Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbZD3TYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbZD3TYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZD3TYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:24:31 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50530 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751815AbZD3TYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:24:30 -0400
Date: Thu, 30 Apr 2009 15:24:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
cc: David VomLehn <dvomlehn@cisco.com>, <linux-usb@vger.kernel.org>,
       <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] USB: Provide USB boot device availability notification
In-Reply-To: <49F9C8E0.30808@ru.mvista.com>
Message-ID: <Pine.LNX.4.44L0.0904301521340.28610-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Sergei Shtylyov wrote:

> Alan Stern wrote:
> 
> >>>+/* The mask of possible USB boot devices depends on what drivers and
> >>>+ * options have been configured into the kernel.  There are too many
> >>>+ * USB network config options to list here, so just assume it is always
> >>>+ * possible to have a USB network device.
> >>>+ */
> >>>+static int usb_bootdev_mask = 0
> >>>+#ifdef CONFIG_USB_SERIAL_CONSOLE
> >>>+				| BOOTDEV_CONSOLE_MASK
> >>>+#endif
> >>>+#if defined(CONFIG_USB_STORAGE) | defined(CONFIG_BLK_DEV_UB)
> 
> >>    It should be ||, not bitwise | here, no?
> 
> > No, it should be bitwise |.  The value being constructed is a union of 
> > disjoint mask bits.
> 
>     I meant the #if line only. Although it shouldn't matter really...

Oh, sorry.  Yes, you're right about that (and you're right that it 
doesn't really matter...).

David, you can go ahead and change the patch, but don't bother to
submit a new version for such a small thing.  The next time this gets 
pushed it'll have the right operator.

Alan Stern

