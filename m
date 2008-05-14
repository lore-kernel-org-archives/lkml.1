Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbYENRYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbYENRYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbYENRX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:23:56 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:45457 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYENRXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:23:55 -0400
Message-ID: <482B1FD7.70108@s5r6.in-berlin.de>
Date: Wed, 14 May 2008 19:22:31 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Georgi Chorbadzhiyski <gf@unixsol.org>
CC: Jan Engelhardt <jengelh@medozas.de>, xfs@oss.sgi.com,
       jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
References: <4828CAC6.3090402@unixsol.org> <alpine.LNX.1.10.0805130115090.25441@fbirervta.pbzchgretzou.qr> <482952F2.3080608@unixsol.org>
In-Reply-To: <482952F2.3080608@unixsol.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Georgi Chorbadzhiyski wrote:
> Jan Engelhardt mumbled something about, On 5/13/08 2:21 AM:
>> On Tuesday 2008-05-13 00:55, Georgi Chorbadzhiyski wrote:
>>>>  1148 ?        S<     0:00  \_ [khpsbpkt]
>>> What is this?
>> 
>> ieee1394/ieee1394_core.c:static struct task_struct *khpsbpkt_thread;
> 
> Strange names :)

Fixed in drivers/firewire/.  :-)

PS:
"k" = kernel
"hpsb" = High Performance Serial Bus ( = IEEE 1394)
"pkt" = packet  (The thread completes split transactions associated with
outbound request packets.)
-- 
Stefan Richter
-=====-==--- -=-= -===-
http://arcgraph.de/sr/
