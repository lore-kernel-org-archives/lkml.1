Return-Path: <linux-kernel-owner+w=401wt.eu-S933371AbYFTUqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbYFTUqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764948AbYFTUeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:34:12 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:29833 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762599AbYFTUeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=gpRveXNAfPv67hCs12LCXYSmNoWgtw4NiRHC5qjwf5J0GMH6TIhnLlLh3UktcAKegJ
         NNLIfnXAPiiWS+UzLA+yr9mzoye84RtT24sjeH/E8IG3Id8XdN9hIomWqSZ/LPJ0Im9S
         ieAIlJFE//9r1kHE5D1qUMw4zAjY8Gwd7x9Dk=
Message-ID: <dd18b0c30806201334r5e28902ehecebf7d70717a8ef@mail.gmail.com>
Date: Fri, 20 Jun 2008 20:34:09 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: appletouch: atp_complete - usb_submit_urb failed with result -1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW I've booted up osx just for the hell of it, and then back to
linux, upon booting linux I'm seeing
something new:  appletouch: atp_complete - usb_submit_urb failed with result -1
when grepping appletouch I see:

[   15.986401] usbcore: registered new interface driver appletouch
[   18.722161] appletouch 1-2:1.1: usb_probe_interface
[   18.726984] appletouch 1-2:1.1: usb_probe_interface - got id
[   18.743669] appletouch: Geyser mode initialized.
[   18.743669] input: appletouch as /class/input/input8
[   25.510074] appletouch: incomplete data package (first byte: 2, length: 4).
[   25.510074] appletouch: atp_complete - usb_submit_urb failed with result -1

even though this message is showing itself, my trackpad is working fine.
regards;

-- 
Justin P. Mattock
