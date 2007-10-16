Return-Path: <linux-kernel-owner+w=401wt.eu-S933135AbXJPKh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbXJPKh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbXJPKhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:37:33 -0400
Received: from kuber.nabble.com ([216.139.236.158]:35474 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182AbXJPKhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:37:32 -0400
Message-ID: <13230720.post@talk.nabble.com>
Date: Tue, 16 Oct 2007 03:37:30 -0700 (PDT)
From: rajashok <ashokrajjb@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Virtual Netdevice
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: ashokrajjb@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

we are trying to to integrate our ipsec onto linux 2.6 kernel to do
so we have created a virtual device [struct net_device] with
dev->type = ARPHRD_VOID and configuring the same MAC address and IP
addresses as present on "eth0" interface and when try to send out the data,
the packets are seen on the network.But we need all the packets
to be processed in the virtual devices "hard_start_xmit" function and this
is never getting called.

Please let me know how to make the kernel call "hard_start_xmit" function of
my virtual device, so i can process the packets in my "hard_start_xmit" and
resend
them on to "Eth0" interface
Do I have to set different IP for virtual device or have to do any other
configurations.

Thanks in advance.

--Ashok


-- 
View this message in context: http://www.nabble.com/Virtual-Netdevice-tf4633398.html#a13230720
Sent from the linux-kernel mailing list archive at Nabble.com.

