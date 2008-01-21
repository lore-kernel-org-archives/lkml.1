Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbYAUBlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbYAUBlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 20:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756802AbYAUBlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 20:41:05 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:32840 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbYAUBlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 20:41:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Vq0P37kKVD1PCFOPKvLh6mtx9FdOrMmhtJwx3cfnwfRMRd5KvhrzJ+MkMc2XaTOyVSCRgrz6p64iHqLnl7SOIBR0X2C3QjM5cv7qtB4jRdffUtp9zEFJcRdyudj8a+CWzAQwuagaTQZJpPkWANyjvmzs0OEuM4fQ7+FUCCWgwwI=
Message-ID: <7d34f9680801201740u4eb912eel921e7890b4ac023a@mail.gmail.com>
Date: Mon, 21 Jan 2008 09:40:59 +0800
From: "william cheng" <opensourcewill@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: modprobing ipmi_si on Dell Power Edge 2600 make the terminal hang kernel ver. >= 2.6.20
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

        We got some problem on modprobing the ipmi_si module on Dell
Power Edge 2600.
        On modprobing the ipmi_si the terminal hang and the process
cannot be terminated by control-C.
        We got these messages in dmesg

        ipmi message handler version 39.1
        IPMI System Interface driver.
        ipmi_si: Trying SMBIOS-specified bt state machine at i/o
address 0xe4, slave address 0x20, irq 10
          Using irq 10
        IPMI BT: req2rsp=10 secs retries=3
        ipmi_si: Error clearing flags: c6


        We have tested a few other dell machine (Power Edge 2500,
2900, ....), and this problem only occurs in Power Edge 2600.


        The problem occurs in the following testes
        Debian testing lenny
        Ubuntu 7.10
        Ubuntu 7.04
        Fedore 8
        Kernel 2.6.20
        Kernel 2.6.21
        Kernel 2.6.22
        Kernel 2.6.22.5
        Kernel 2.6.22.14
        Kernel 2.6.22.15
        Kernel 2.6.23.12

        While in the following testes we can successfully modprobe the ipmi_si
        Ubuntu 6.10
        Debian 4.0r2
        Kernel 2.6.18.3
        Kernel 2.6.18.5
        Kernel 2.6.18.8
        Kernel 2.6.19
        Kernel 2.6.19.7

        It looks like the problem only occurs when using kernel after
2.6.20 with Power Edge 2600.
        Anyone know the reason for that?
        Any additional information should I provide?
        Thanks
William
