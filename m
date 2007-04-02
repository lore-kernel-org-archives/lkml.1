Return-Path: <linux-kernel-owner+w=401wt.eu-S933996AbXDBMZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996AbXDBMZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 08:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934003AbXDBMZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 08:25:14 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:44663 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbXDBMZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 08:25:12 -0400
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
From: Marcel Holtmann <marcel@holtmann.org>
To: Li Yu <raise.sail@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, hongzhiyi@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       yanghong@ccoss.com.cn, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <460B507E.60305@gmail.com>
References: <200703051532096508636@gmail.com>  <45FE6971.6090503@gmail.com>
	 <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn>
	 <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>
	 <460B507E.60305@gmail.com>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 14:19:51 +0200
Message-Id: <1175516391.5815.343.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

> > JFYI the preliminary version of the hidraw interface is now in the 
> > hid/usbhid git tree, and has also been in a few recent -mm kernels 
> > already.
> >
> >   
> The shadow driver support works now.
> 
> The most largest problem is HID/Bluetooth can not work now. And, I have
> no any bluetooth input device to test, So ...

if this doesn't work, then the complete design is bogus. There is no
difference between USB and Bluetooth. The HID core takes care of
abstracting it.

Regards

Marcel


