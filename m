Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbYISHAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbYISHAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 03:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbYISHAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 03:00:05 -0400
Received: from mail.dgt.com.pl ([94.40.14.70]:45609 "EHLO dgt.com.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbYISHAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 03:00:04 -0400
X-Greylist: delayed 2258 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Sep 2008 03:00:03 EDT
DGT-Virus-Scanned: amavisd-new at dgt.com.pl
Message-ID: <48D3451D.1080807@dgt.com.pl>
Date: Fri, 19 Sep 2008 08:22:21 +0200
From: Wojciech Kromer <wojciech.kromer@dgt.com.pl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080305)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: NFS root + iptables in 2.6.25
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'm using nfs root filesystem for developing.
On 2.6.23 everything works fine, but on 2.6.25 loading any iptables
module causes problems:


# modprobe iptable_nat
nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
nfs: RPC call returned error 1
nfs: RPC call returned error 1
nfs: RPC call returned error 1
nfs: RPC call returned error 1
nfs: RPC call returned error 1
nfs: RPC call returned error 1


Probably iptables changed it's default behavior from "allow all" to
"deny all" at startup.
Is there any way to change it back?
I can't change anything after loading any iptable module, because all
programs on filesystem are not accessible after loading...


Regards.

