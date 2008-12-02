Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbYLBP6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbYLBP6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:58:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYLBP5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:57:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:41540 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751163AbYLBP5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:57:54 -0500
X-Authenticated: #25273218
X-Provags-ID: V01U2FsdGVkX1+R8xV3336RB0ykutjXscNz+ouZgVQdlt40JyfAWd
	uIAHPMnv/lGzPg
Message-ID: <0FF8E27EC45B4FDB903F8B368059568E@cyberweb>
From: "Sirius" <sirius@sonnenkinder.org>
To: <linux-kernel@vger.kernel.org>
Subject: Concerning EHCI BIOS handoff timeout
Date: Tue, 2 Dec 2008 16:57:53 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6899999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone!

My BIOS seems to be buggy when it comes to the EHCI BIOS handoff process (at 
least that's what syslog is telling me). That's why I need to wait for the 
timeout (five seconds) to happen EVERY boot. So I know in advance that 
something won't happen but still I need to wait for it - not to happen.

Of course I could just change the timeout to 0 in 
/drivers/usb/host/pci-quirks.c but then all the benefits from running my 
distribution's kernel would be gone.

I think there should be a way (maybe via a kernel boot parameter?) to tell 
the kernel that there is no need to wait.

Thanks for your input,
Sirius 

