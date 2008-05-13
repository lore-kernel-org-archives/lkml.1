Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbYEMIgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbYEMIgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757281AbYEMIgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:36:05 -0400
Received: from ns.unixsol.org ([193.110.159.2]:32938 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985AbYEMIgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:36:05 -0400
Message-ID: <482952F2.3080608@unixsol.org>
Date: Tue, 13 May 2008 11:36:02 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
Organization: Unix Solutions Ltd.
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: xfs@oss.sgi.com, jfs-discussion@lists.sourceforge.net,
       cluster-devel@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
References: <4828CAC6.3090402@unixsol.org> <alpine.LNX.1.10.0805130115090.25441@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0805130115090.25441@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt mumbled something about, On 5/13/08 2:21 AM:
> On Tuesday 2008-05-13 00:55, Georgi Chorbadzhiyski wrote:
>> Not needed here, because no jfs partition is in use.
>> Not needed here, because no xfs partition is in use.
>> I dont use gfs2
> 
> You miss the best of Linux. So, why not unload the modules?

ext3 is working just fine for now, thanks (:

>>>  1141 ?        S<     0:00  \_ [block-osm/1]
>> What is osm? Can't find anything in kernel config?
> 
> drivers/message/i2o/i2o_block.c:#define OSM_NAME        "block-osm"
> 
>>>  1148 ?        S<     0:00  \_ [khpsbpkt]
>> What is this?
> 
> ieee1394/ieee1394_core.c:static struct task_struct *khpsbpkt_thread;

Strange names :)

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/

