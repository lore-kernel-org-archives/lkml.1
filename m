Return-Path: <linux-kernel-owner+w=401wt.eu-S1751308AbXDCDlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbXDCDlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 23:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbXDCDlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 23:41:49 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:32041 "EHLO
	asav01.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbXDCDlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 23:41:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAKhpEUZKhRO4UGdsb2JhbACHPIhDAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Li Yu <raise.sail@gmail.com>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
Date: Mon, 2 Apr 2007 23:41:47 -0400
User-Agent: KMail/1.9.3
Cc: Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Jiri Kosina <jkosina@suse.cz>, Marcel Holtmann <marcel@holtmann.org>
References: <56464.192.54.193.51.1175515024.squirrel@rousalka.dyndns.org> <4611B0A1.8070106@gmail.com>
In-Reply-To: <4611B0A1.8070106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704022341.48603.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 21:40, Li Yu wrote:
> May be, we need some means to change blacklist in runtime. and
> loading/unloading such driver by specific script to do it.

Please look at the new_id sysfs attribute implementation in
drivers/pci/pci-driver.c. I believe we need something similar
to dynamically adjust HID ignore blacklist.

-- 
Dmitry
