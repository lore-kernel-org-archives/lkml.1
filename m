Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691Ab0ALOyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab0ALOyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 09:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149Ab0ALOym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 09:54:42 -0500
Received: from kroah.org ([198.145.64.141]:34498 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab0ALOym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 09:54:42 -0500
Date: Tue, 12 Jan 2010 06:45:53 -0800
From: Greg KH <greg@kroah.com>
To: Steven Xu <linuxkernel.xxz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A QUESTION ABOUT USB DRIVER
Message-ID: <20100112144553.GA26050@kroah.com>
References: <1fd295ee1001102114p1b74336q16bb35d973b40c1c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fd295ee1001102114p1b74336q16bb35d973b40c1c@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 01:14:31PM +0800, Steven Xu wrote:
> output: usb 1-1: device descriptor read/64, error -71
> 
> 
> in drivers/usb/core/hub.c  line 2250
> when a udisk inserted run to here
>                         for (j = 0; j < 3; ++j) {
>                                 buf->bMaxPacketSize0 = 0;
> 
>                                 r = usb_control_msg(udev, usb_rcvaddr0pipe(),
>                                         USB_REQ_GET_DESCRIPTOR, USB_DIR_IN,
>                                         USB_DT_DEVICE << 8, 0,
>                                         buf, GET_DESCRIPTOR_BUFSIZE,
>                                         (i ? USB_CTRL_GET_TIMEOUT : 1000));
>  return r=-74,
> 
> WHAT IS THE POSSIBEL REASON FOR THIS?

It is needed, why, are you having problems with it?

thanks,

greg k-h
