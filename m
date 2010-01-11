Return-Path: <linux-kernel-owner+w=401wt.eu-S1751476Ab0AKFOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab0AKFOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 00:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208Ab0AKFOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 00:14:32 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:45827 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab0AKFOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 00:14:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=YZXHbpmO3OdBTnPfO3Q78h2/Lq4/4M5lMraDdjSZASiB0/TXG2SBjpkxJ9j/7o31FW
         /bZRjrSiqzdcXWSazdGYqxe9XfjEpJgYkp84eI4pNzMdUp4haFOVx2cwJ9dcaR+UKFYO
         ngWfaqZu/GxZ+okZB8ly8mwFsmF8n4qBgfavQ=
MIME-Version: 1.0
Date: Mon, 11 Jan 2010 13:14:31 +0800
Message-ID: <1fd295ee1001102114p1b74336q16bb35d973b40c1c@mail.gmail.com>
Subject: A QUESTION ABOUT USB DRIVER
From: Steven Xu <linuxkernel.xxz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

output: usb 1-1: device descriptor read/64, error -71


in drivers/usb/core/hub.c  line 2250
when a udisk inserted run to here
                        for (j = 0; j < 3; ++j) {
                                buf->bMaxPacketSize0 = 0;

                                r = usb_control_msg(udev, usb_rcvaddr0pipe(),
                                        USB_REQ_GET_DESCRIPTOR, USB_DIR_IN,
                                        USB_DT_DEVICE << 8, 0,
                                        buf, GET_DESCRIPTOR_BUFSIZE,
                                        (i ? USB_CTRL_GET_TIMEOUT : 1000));
 return r=-74,

WHAT IS THE POSSIBEL REASON FOR THIS?
THANKS!
