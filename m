Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbYIXSCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbYIXSCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYIXSCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:02:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:7503 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYIXSCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=AeMEZ6Omg+pqDtfoNEwHm4yVjRMHXOwbi6naYC7oBnPf1SwcZFfaVewDP3TvQVDVN6
         qRnDvdpg6LY4Bw/Wxho3X4ZkDL0qucXdxmANaK+j2Y0gT20Z1VfUZhFAbZtMq3DUFOHS
         FCW/JyKwr/TKcFnVmtrbc9PD4lT8R+cT+6dpQ=
Message-ID: <762793250809241102n61ea8f00kca8138bc3c8df2e6@mail.gmail.com>
Date: Wed, 24 Sep 2008 19:02:27 +0100
From: "Paul Eddington" <eddingtonpaul@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Bug in rt2x00 rt73usb driver in latest git kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While running the latest git kernel (linus' tree) and using a usb wifi
card, I got this error in dmesg:;

phy2 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry
in the non-full queue 2.
Please file bug report to http://rt2x00.serialmonkey.com.

This is not reproducible easily, but it has occurred on two occasions
both while connected to a WEP encrypted AP with a 40-bit key and
performing many file samba transfers at full speed 54mbits.

I tried to report the bug there but was unable to register and edit
the bug reports wiki page.
If there is any more information or help required to debug this,
please let me know.

Regards,
Paul
