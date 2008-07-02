Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYGBIgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYGBIgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYGBIgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:36:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58798 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYGBIgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:36:40 -0400
Message-ID: <486B3D06.8080208@cn.fujitsu.com>
Date: Wed, 02 Jul 2008 16:32:06 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kobjects: Transmit return value of kobject_uevent_env()
 to caller
References: <4860B75A.1050307@cn.fujitsu.com>	<20080624162448.4b1e3d87@gondolin.boeblingen.de.ibm.com>	<486198F1.6000601@cn.fujitsu.com>	<48620B15.9060608@cn.fujitsu.com> <20080701125124.34817629@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080701125124.34817629@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck said the following on 2008-7-1 18:51:
> On Wed, 25 Jun 2008 17:08:37 +0800,
> Wang Chen <wangchen@cn.fujitsu.com> wrote:
> 
>> It's depended on how important sending uevent is.
>> If the sysfs operation succeeds, but user-space don't
>> get the notification. Is it ok?
> 
> Given that (a) there may be no listener, (b) sending via netlink may
> succeed but calling uevent_helper may fail (highly unlikely the way
> modern distros are set up, though), and (c) you would have to audit a
> myriad places that don't check for the return code of kobject_uevent()
> today as well, it looks like the best way is to simply add some
> pr_debug()s to kobject_uevent_env() where something fails.
> 

Fair enough. Thanks Cornelia.
Greg, please ignore this patch.
But please take a look at "[PATCH 1/2] kobjects: Transmit return value of call_usermodehelper() to caller".

