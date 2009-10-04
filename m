Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbZJDAfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbZJDAfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 20:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZJDAfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 20:35:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:56758 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbZJDAfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 20:35:52 -0400
Message-ID: <4AC7EDD7.3080906@kernel.org>
Date: Sun, 04 Oct 2009 09:35:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Colin Guthrie <cguthrie@mandriva.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: get_device_parent() race bug
References: <4ABC7DB5.9010402@kernel.org>
In-Reply-To: <4ABC7DB5.9010402@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 04 Oct 2009 00:34:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Greg, Kay, Guthrie.
> 
> This problem was reported in bko#14023.  (aiee.. again, sorry about
> the delay)
> 
>   http://bugzilla.kernel.org/show_bug.cgi?id=14023
> 
> sysfs is creating several devices in cuse class concurrently and with
> CONFIG_SYSFS_DEPRECATED turned off, it triggers the following oops.
> 
>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000038

Ping.  This one needs to be fixed in -stable.  It can be triggered by
other char devices too.

Thanks.

-- 
tejun
