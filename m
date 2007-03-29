Return-Path: <linux-kernel-owner+w=401wt.eu-S964883AbXC2FiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883AbXC2FiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 01:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965970AbXC2FiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 01:38:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:16806 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964883AbXC2FiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 01:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=uDT/OauIOEKDOpA1aPRM0m1nkheh2JDqwE1G6UFZA78cw75FU8YPmbuQOUbBWOXVDebrOtBM91G4dMRYjUCWh3yBClWRY5oZeG3SJNgJN+zp+YzUaOiKi7d2mEvk0j9vhxPmcWIgw/YGZ0/Qbfuh38PKieuMKRlGXd1n7M7BKd4=
Message-ID: <460B507E.60305@gmail.com>
Date: Thu, 29 Mar 2007 13:37:02 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Marcel Holtmann <marcel@holtmann.org>, Li Yu <raise.sail@gmail.com>,
       hongzhiyi@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       yanghong@ccoss.com.cn, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
References: <200703051532096508636@gmail.com>  <45FE6971.6090503@gmail.com> <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn> <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> JFYI the preliminary version of the hidraw interface is now in the 
> hid/usbhid git tree, and has also been in a few recent -mm kernels 
> already.
>
>   
The shadow driver support works now.

The most largest problem is HID/Bluetooth can not work now. And, I have
no any bluetooth input device to test, So ...

I think I should port current implementation to 2.6.21-rc5-mm2, and
support hiddev, then release it.

The last word is a question, what's the future of hiddev? It will merge
into hidraw later?  I think so, but can't sure.
