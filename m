Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbYJKN6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbYJKN6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 09:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbYJKN6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 09:58:08 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2366 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753127AbYJKN6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 09:58:07 -0400
Date: Sat, 11 Oct 2008 09:58:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Franko Fang <huananhu@huawei.com>
cc: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <zihan@huawei.com>,
       <zhangqianchun@huawei.com>
Subject: Re: PATCH 10/8]linux-usb: To support more Huawei data card productIDs,
 fix kernel 2.6.27-rc7
In-Reply-To: <003f01c92b58$be5a11a0$f9100b0a@china.huawei.com>
Message-ID: <Pine.LNX.4.44L0.0810110953390.13572-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Oct 2008, Franko Fang wrote:

> Dear Greg and Alan,
> 
> Well, OK, but I will change it as follows:
>  
>   result = usb_stor_control_msg(us, us->send_ctrl_pipe,
>            USB_REQ_SET_FEATURE,
>            USB_TYPE_STANDARD | USB_RECIP_DEVICE,
>            0x01, 0x0, NULL, 0x0, 1000);
> 
> Because the parameters of USB_REQ_SET_FEATURE, USB_TYPE_STANDARD and
> USB_RECIP_DEVICE are all Hex, so I want to keep my other parameters
> to be consistant with them.

Actually they aren't hex; they are expressions using pre-processor
macros.  However the value and index arguments are hex (0x01 and 0x0);
they could be changed too.

> And I see the same using with me in the kernel. Such as the code of
> the function usb_stor_euscsi_init in initializers.c file.

It doesn't really matter.  If it were up to me, I'd change the code in 
usb_stor_euscsi_init also.

> Is this changing can be accepted by you? 

Yes.

Alan Stern

