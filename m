Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbZDOKHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbZDOKHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZDOKHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:07:17 -0400
Received: from mail-gx0-f208.google.com ([209.85.217.208]:56186 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbZDOKHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:07:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=NedFX5byWG1MmUq8xhKP/95uqZebK8SG5MjTT7U2Ohdd/Qt+Cn6vZmwnWsRJU6APjM
         /yNmdxsVylXFxD7YM7jq0fF/bGmBeYo9Mu0QCiupCiA/WVGafWTiEWXgW6Yn5uYQ7hlu
         M6YqmVTaKahYCfa2LGO2soobS2PWPmNnLXCT4=
Message-ID: <49E5B2F3.4080502@tuffmail.co.uk>
Date: Wed, 15 Apr 2009 11:12:03 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-uvc-devel@lists.berlios.de, linux-pm@lists.linux-foundation.org
CC: USB list <linux-usb@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Regression: active uvcvideo breaks over suspend
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found this in v2.6.30-rc2.  I haven't tested beyond that.  I'm sure it 
didn't happen in 2.6.29.

If I run "xawtv" and then suspend, it stops working on resume; the xawtv 
display goes black and the camera LED stays off.  When I close xawtv, 
the LED blinks on then off again.  If I then try to run xawtv again, it 
works fine.

In dmesg (after resume) I see

[  562.884298] usb 1-8: type resume
[  562.990014] usb 1-8: reset high speed USB device using ehci_hcd and 
address 3
[  563.665921] restoring control 00000000-0000-0000-0000-000000000101/0/2
[  563.665935] restoring control 00000000-0000-0000-0000-000000000101/1/3
[  563.665948] restoring control 00000000-0000-0000-0000-000000000101/3/7
[  563.666412] uvcvideo 1-8:1.1: reset_resume error -12

Thanks in advance
Alan
