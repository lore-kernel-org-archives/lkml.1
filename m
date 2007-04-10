Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbXDJJfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbXDJJfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 05:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXDJJfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 05:35:53 -0400
Received: from styx.suse.cz ([82.119.242.94]:37021 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752864AbXDJJfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 05:35:51 -0400
Date: Tue, 10 Apr 2007 11:40:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Li Yu <raise.sail@gmail.com>
Cc: yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: HID bus prototype - 20070408
In-Reply-To: <46189FE3.6050206@gmail.com>
Message-ID: <Pine.LNX.4.64.0704101136330.13232@jikos.suse.cz>
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com>
 <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn>
 <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>
 <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>
 <1175516515.5815.347.camel@violet> <Pine.LNX.4.64.0704021429420.3808@jikos.suse.cz>
 <1175532439.5815.375.camel@violet> <4611AAC1.8050303@gmail.com>
 <Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz> <02f801c7770d$3eafb050$84163e05@kroptech.com>
 <Pine.LNX.4.64.0704050109500.4173@jikos.suse.cz> <036401c77711$cee286d0$84163e05@kroptech.com>
 <46189FE3.6050206@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Apr 2007, Li Yu wrote:

> 	The attachment is the latest HID bus prototype. It have such changes:
> 	0. Move the hidp directory from net/bluetooth/ to drivers/hid/.

Hi Li,

we have been discussing this with Marcel previously, and the decission was 
to let the hidp code where it is right now, due to it being very closely 
connected to the bluetooth network stack.

> 	1. HID/Bluetooth support, ONLY FOR HIGHLY EXPERIMENT. I have no 
>          any such device to test yet.

I didn't have time yet to review the patch you sent previously, but I 
don't still quite understand why does the transport layer matter here? The 
generic HID layer, as it is in kernel now, makes an abstraction in a way 
that the HID-specific drivers should not care about the underlying 
transport layer.

> 	I am sorry for it is not in patch form.

That's quite unfortunate. I'll try to review it nevertheless, but it'd be 
much more convenient if you manage to send a patch.

Thanks,

-- 
Jiri Kosina
