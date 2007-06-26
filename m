Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbXFZOkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbXFZOkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbXFZOkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:40:11 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49315 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbXFZOkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:40:09 -0400
Message-ID: <468123D9.6030001@zytor.com>
Date: Tue, 26 Jun 2007 10:34:01 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: Ram Pai <linuxram@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] VFS: Augment /proc/mount with subroot and shared-subtree
References: <20070620210343.GQ21478@ftp.linux.org.uk> <46799A31.10301@zytor.com> <1182442837.3342.13.camel@ram.us.ibm.com> <467AB5EE.3030909@zytor.com> <1182494654.2812.22.camel@ram.us.ibm.com> <467B7509.8010106@zytor.com> <1182497690.2812.54.camel@ram.us.ibm.com> <467B7F6F.4030007@zytor.com> <20070625214640.GC29058@ram.us.ibm.com> <1182808816.2816.7.camel@ram.us.ibm.com> <20070626080104.GB4099@petra.dvoda.cz>
In-Reply-To: <20070626080104.GB4099@petra.dvoda.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karel Zak wrote:
> 
>  (BTW, maybe we can completely remove "freq, passno" from
>  /proc/mounts, especially if we don't have care about compatibility
>  with /etc/{mtab,fstab} format. The freq and passno are always zero in
>  /proc/mounts).
> 

But we do, since there are applications which use getmntent() and 
friends to parse /proc/mounts.

	-hpa

