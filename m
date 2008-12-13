Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbYLMJaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbYLMJaT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 04:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbYLMJaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 04:30:03 -0500
Received: from mirapoint3.brutele.be ([212.68.199.148]:7967 "EHLO
	mirapoint3.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbYLMJaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 04:30:00 -0500
Message-ID: <49438093.9030809@tvcablenet.be>
Date: Sat, 13 Dec 2008 10:29:55 +0100
From: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?= 
	<francois.valenduc@tvcablenet.be>
User-Agent: Thunderbird 2.0.0.18 (X11/20081123)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/83] 2.6.27.9-stable review
References: <20081211191014.GA5759@suse.de>
In-Reply-To: <20081211191014.GA5759@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Junkmail-Status: score=10/50, host=mirapoint3.brutele.be
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A0B0208.49438095.01B0,ss=1,fgs=0,
	ip=192.168.1.2,
	so=2008-05-01 23:44:25,
	dmn=5.7.1/2008-09-02
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH a écrit :
> This is the start of the stable review cycle for the 2.6.27.9 release.
> There are 83 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
> 
> These patches are sent out with a number of different people on the Cc:
> line.  If you wish to be a reviewer, please email stable@kernel.org to
> add your name to the list.  If you want to be off the reviewer list,
> also email us.
> 
> Responses should be made by December 13, 2008, 20:00:00 UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.9-rc1.gz
> and the diffstat can be found below.
> 
> 
> thanks,
> 
> greg k-h

Would it be possible to add these two patches ?

commit 8258becf07e71236aac8cf5406a1345712f9ac25
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Sep 23 19:18:43 2008 +0200

     iwlagn: downgrade BUG_ON in interrupt

commit 199d9de726ff2f949405279665a9c8b38966239b
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Nov 18 01:47:21 2008 +0100

     iwlagn: fix RX skb alignment

Without these ones, my computer freezes very frequently (see bugs 11393, 
11983 and 12173 which in fact is a duplicate of the previous one).
These two patches can be applied without any rejects on kernel 2.6.27.8.

Thanks,
François Valenduc
