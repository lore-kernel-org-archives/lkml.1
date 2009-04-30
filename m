Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbZD3Tt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbZD3Tt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZD3Tts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:49:48 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:2063 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZD3Ttr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:49:47 -0400
X-IronPort-AV: E=Sophos;i="4.40,274,1238976000"; 
   d="scan'208";a="74104758"
Date: Thu, 30 Apr 2009 12:49:47 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-usb@vger.kernel.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] USB: Provide USB boot device availability
	notification
Message-ID: <20090430194947.GB16896@cuplxvomd02.corp.sa.net>
References: <49F9C8E0.30808@ru.mvista.com> <Pine.LNX.4.44L0.0904301521340.28610-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904301521340.28610-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-1; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 03:24:30PM -0400, Alan Stern wrote:
> On Thu, 30 Apr 2009, Sergei Shtylyov wrote:
> 
> > Alan Stern wrote:
> > 
> > >>>+/* The mask of possible USB boot devices depends on what drivers and
> > >>>+ * options have been configured into the kernel.  There are too many
> > >>>+ * USB network config options to list here, so just assume it is always
> > >>>+ * possible to have a USB network device.
> > >>>+ */
> > >>>+static int usb_bootdev_mask = 0
> > >>>+#ifdef CONFIG_USB_SERIAL_CONSOLE
> > >>>+				| BOOTDEV_CONSOLE_MASK
> > >>>+#endif
> > >>>+#if defined(CONFIG_USB_STORAGE) | defined(CONFIG_BLK_DEV_UB)
> > 
> > >>    It should be ||, not bitwise | here, no?
> > 
> > > No, it should be bitwise |.  The value being constructed is a union of 
> > > disjoint mask bits.
> > 
> >     I meant the #if line only. Although it shouldn't matter really...
> 
> Oh, sorry.  Yes, you're right about that (and you're right that it 
> doesn't really matter...).
> 
> David, you can go ahead and change the patch, but don't bother to
> submit a new version for such a small thing.  The next time this gets 
> pushed it'll have the right operator.

Done. It will be in the next submission.

> Alan Stern

David VomLehn
