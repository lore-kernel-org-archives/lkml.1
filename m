Return-Path: <linux-kernel-owner+w=401wt.eu-S1423068AbXBBNdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423068AbXBBNdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 08:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423065AbXBBNdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 08:33:49 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:34114 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423058AbXBBNds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 08:33:48 -0500
Date: Fri, 2 Feb 2007 14:27:29 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
cc: Netdev <netdev@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]ip_auto_config bug in 2.6.20-rc6
In-Reply-To: <1170421783.15627.23.camel@gentoo-jocke.transmode.se>
Message-ID: <Pine.LNX.4.61.0702021424381.26531@yvahk01.tjqt.qr>
References: <1170329187.15627.11.camel@gentoo-jocke.transmode.se>
 <1170421783.15627.23.camel@gentoo-jocke.transmode.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 2 2007 14:09, Joakim Tjernlund wrote:
>On Thu, 2007-02-01 at 12:26 +0100, Joakim Tjernlund wrote:
>> The following commandline:
>>  root=/dev/mtdblock6 rw rootfstype=jffs2 ip=192.168.1.10:::255.255.255.0:localhost.localdomain:eth1:off console=ttyS0,115200
>> makes ip_auto_config fall back to DHCP and complain "IP-Config: Incomplete network configuration information."
>> depending on if CONFIG_IP_PNP_DHCP is set or not.
>> 
>> The only way I can make ip_auto_config accept my IP config is to add an entry for the server IP:
>> ip=192.168.1.10:192.168.1.15::255.255.255.0:localhost.localdomain:eth1:off
>> 
>> I think this is a bug since I am not using a NFS root FS.

I just wonder why IP_PNP has not been obsoleted and removed from the 
tree yet, given that initramfs is the advertised way to do so such 
things.


Jan
-- 
