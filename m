Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbYAGFrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbYAGFrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 00:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYAGFr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 00:47:29 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:53551 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbYAGFr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 00:47:29 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: linux-kernel@vger.kernel.org
Subject: bugreport kernel panic on early stage, with HIGHMEM4G:
Date: Mon, 7 Jan 2008 07:47:18 +0200
Message-Id: <20080107053908.M5584@visp.net.lb>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

After physical memory upgrade from 3GB to 4GB (also it happens on 5GB) got 
kernel panic.

Because it is happening on early stage and my machine doesn't contain serial 
port, i had to take photo.
Kernel boots fine with 64GB highmem, no highmem, or highmem4G with limited 
memory by mem=3G. All dmesg attached.
Also i attach dmidecode and lspci -vvv output, probably it will be useful.


Photo (2.8MB, sorry, just original size from camera):
http://www.nuclearcat.com/files/panic-07012008/img_1232.jpg

dmesg without highmem
http://www.nuclearcat.com/files/panic-07012008/dmesg-nohighmem.txt

with highmem64G
http://www.nuclearcat.com/files/panic-07012008/dmesg-highmem64G.txt

with highmem4G limited by mem=3G
http://www.nuclearcat.com/files/panic-07012008/dmesg-highmem4G-memlim3G.txt
Kernel config for this specific boot:
http://www.nuclearcat.com/files/panic-07012008/config.txt

dmidecode output
http://www.nuclearcat.com/files/panic-07012008/dmidecode.txt

lspci output
http://www.nuclearcat.com/files/panic-07012008/lspci.txt

--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

