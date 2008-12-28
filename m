Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYL1Uem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYL1Uem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 15:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbYL1Uee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 15:34:34 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:35213 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYL1Ued (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 15:34:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=QGCLFETVxwafBF9BDv1EtJ2UlZEYcJjW8m+aTzFr7UhZcW19MDJn+fZ7iLQ+AmY2bA
         vT26bLmF9cHU8vaR2Kk7jzPij3BCTiNUgaPzwT34Inrxx1SUAzSS/s0UjutHCQwmt5oV
         MWE8i6oJgv2aEzMBpothQDHUrKl6wnBVcs87o=
Message-ID: <a00b9da20812281234u76da2ef5tb715f4c409eaf37c@mail.gmail.com>
Date: Sun, 28 Dec 2008 21:34:32 +0100
From: "Frank Groeneveld" <frankgroeneveld@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.28 regression: Hang after hibernate
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Today I tried the new kernel and found out it has a regression. With
kernel 2.6.27 I never had problems resuming from hibernate, but with
2.6.28 it hangs. The output is something like this (it's not exactly,
I skipped some words that are before the PCI lines):

PM: read .. MB in .. seconds
SDA: Synchronizing SCSI cache
r8169: PME# enabled
PCI INT A disabled
PCI INT D disabled
PCI INT B disabled
PCI INT C disabled
PCI INT D disabled
PCI INT A disabled
Disabling non-boot CPUs
CPU1 is now offline
CPU1 is down
CPU2 is now offline
CPU2 is down
CPU3 is now offline
CPU3 is down
SMP Alternatives: switching to UP code

I first thought it's the same as bug 12155, but I'm not sure it is.
If there's any other ouput I can send to help, let me know.

Regards,
Frank Groeneveld
