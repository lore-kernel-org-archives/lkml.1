Return-Path: <linux-kernel-owner+w=401wt.eu-S1764153AbZD3P5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764153AbZD3P5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933079AbZD3Ptn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:49:43 -0400
Received: from h155.mvista.com ([63.81.120.155]:46079 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933074AbZD3Ptk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:49:40 -0400
Message-ID: <49F9C8E0.30808@ru.mvista.com>
Date: Thu, 30 Apr 2009 19:50:56 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David VomLehn <dvomlehn@cisco.com>, linux-usb@vger.kernel.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] USB: Provide USB boot device availability notification
References: <Pine.LNX.4.44L0.0904301131530.20151-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0904301131530.20151-100000@netrider.rowland.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:

>>>+/* The mask of possible USB boot devices depends on what drivers and
>>>+ * options have been configured into the kernel.  There are too many
>>>+ * USB network config options to list here, so just assume it is always
>>>+ * possible to have a USB network device.
>>>+ */
>>>+static int usb_bootdev_mask = 0
>>>+#ifdef CONFIG_USB_SERIAL_CONSOLE
>>>+				| BOOTDEV_CONSOLE_MASK
>>>+#endif
>>>+#if defined(CONFIG_USB_STORAGE) | defined(CONFIG_BLK_DEV_UB)

>>    It should be ||, not bitwise | here, no?

> No, it should be bitwise |.  The value being constructed is a union of 
> disjoint mask bits.

    I meant the #if line only. Although it shouldn't matter really...

> Alan Stern

WBR, Sergei
