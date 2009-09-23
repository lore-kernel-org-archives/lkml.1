Return-Path: <linux-kernel-owner+w=401wt.eu-S1751508AbZIWEhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbZIWEhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 00:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZIWEhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 00:37:45 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:5365 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZIWEho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 00:37:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=k+c7Lxjh/mEypQQLid8jkY4TXVFHYMUYa4nK+91mtQySMlKKY+ByqnqSkr9mTrSogu
         DnoJMrCcmbQ1eKskd6UttRg5EWRujBL2hJtrYV9wVBnUtqjSb5ecX0xUTr/DsSHGRi2C
         hy6UsZ7NGODwbt48V2kb6lYhsLQh92bPKCvw4=
MIME-Version: 1.0
Date: Wed, 23 Sep 2009 12:37:48 +0800
Message-ID: <505766fa0909222137q217be3d0x8fc12ab467833666@mail.gmail.com>
Subject: Linux guest domain with two vnets bound to the same vswitch 
	experiences hung in bootup (sun_netraT5220)
From: hyl <heyongli@gmail.com>
To: sparclinux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

console output:

e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e: Copyright (c) 1999-2008 Intel Corporation.
sunvnet.c:v1.0 (June 25, 2007)
sunvnet.c:v1.0 (June 25, 2007)
eth0: Sun LDOM vnet 00:14:4f:f9:68:e0:t
e0
eth0: PORT ( remote-mac 00:14:4f:fa:03:81 switch-port )
eth0: PORT ( remote-mac 00:14:4f:fa:03:81 switch-port )
eth0: PORT ( remote-mac 00:14:4f:f9:84:06 )
eth0: PORT ( remote-mac 00:14:4f:f9:84:06 )
eth0: PORT ( remote-mac 00:14:4f:f9:9a:40 )
eth0: PORT ( remote-mac 00:14:4f:f9:9a:40 )
eth0: PORT ( remote-mac 00:14:4f:f8:c5:7b )
eth0: PORT ( remote-mac 00:14:4f:f8:c5:7b )
eth1: Sun LDOM vnet 00:14:4f:f8:c5:7b:t
7b
eth1: PORT ( remote-mac 00:14:4f:fa:03:81 switch-port )
eth1: PORT ( remote-mac 00:14:4f:fa:03:81 switch-port )
eth1: PORT ( remote-mac 00:14:4f:f9:84:06 )
eth1: PORT ( remote-mac 00:14:4f:f9:84:06 )
eth1: PORT ( remote-mac 00:14:4f:f9:9a:40 )
eth1: PORT ( remote-mac 00:14:4f:f9:9a:40 )
eth1: PORT ( remote-mac 00:14:4f:f9:68:e0 )
eth1: PORT ( remote-mac 00:14:4f:f9:68:e0 )

two vnets bound to the same vswitch, then hang,
ldm add-vnet vnet0 primary-vsw1 dom1
ldm add-vnet vnet1 primary-vsw1 ldom1

If 'eth1' and 'eth2' are bound to different vswitches, everything is fine.


Yongli He
