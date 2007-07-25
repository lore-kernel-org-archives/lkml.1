Return-Path: <linux-kernel-owner+w=401wt.eu-S1762963AbXGYIaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762963AbXGYIaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 04:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXGYIaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 04:30:08 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:45156 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbXGYIaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 04:30:06 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Tino Keitel <tino.keitel@gmx.de>, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.23-rc1: USB hard disk broken
Date: Wed, 25 Jul 2007 10:24:36 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20070725072343.GA3483@dose.home.local>
In-Reply-To: <20070725072343.GA3483@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251024.37112.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 25 Juli 2007 schrieb Tino Keitel:
> Hi,
> 
> I just tried 2.6.23-rc1 and shortly after the boot my external USB hard
> disk went mad.
> 
> I all started with these kernel messages:
> 
> kern.info: usb 1-6: USB disconnect, address 5
> kern.info: sd 4:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
> kern.warn: end_request: I/O error, dev sdb, sector 680000479
> kern.alert: I/O error in filesystem ("dm-2") meta-data dev dm-2 block 0x6c7fa20
> ("xfs_trans_read_buf") error 5 buf count 8192
> 
> The full kernel log can be found here:
> 
> http://tikei.de/kernel.log
> 
> And the config:
> 
> http://tikei.de/kernel.config
> 
> Needless to say that it all worked fine with 2.6.22.

Please recompile with CONFIG_USB_DEBUG set.

	Regards
		Oliver
