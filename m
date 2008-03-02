Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYCBBGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYCBBGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 20:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYCBBFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 20:05:53 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:23678 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbYCBBFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 20:05:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=AzXMIaGkkPIQjN3+OP0Ln/gC/zVvwD57LMR4sU9B0ByW4BxX86MZ7Wvn0Fz2cE5a42ktBZZKfhmMrkhYYKEVwwpDDYdEvWNkCR+2p1oZPk49xI0uxHZxcNr6gVPVpQF07kDheRbbCjEZN3nNKFoVGPCMtxAkZdYoUKbAiISLPZ4=
Message-ID: <2c0942db0803011705j260186bbgb02dcd8f9842e52b@mail.gmail.com>
Date: Sat, 1 Mar 2008 17:05:50 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "kernel list" <linux-kernel@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       linux-wireless@vger.kernel.org
Subject: Oops in mac80211:rate_control_pid_tx_status
Cc: "John Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 179148ae515a68ba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel version 2.6.24+ a little (but pre-rc1).

I have a wireless base station that I switched from B/G mixed mode to
purely B to try to debug a separate issue with a different device on
my network. As soon as I did that (and on every subsequent boot), the
system oopses as soon as it tries to associate. Switching the base
station back to "mixed" avoids the oops.

This is with the b43 driver.

Nothing gets to the logs, but there's a photo at:
    http://madrabbit.org/~ray/mac80211-oops.jpg

Ray
