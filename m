Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbXG3OUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbXG3OUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760941AbXG3OUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:20:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36727 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759320AbXG3OUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:20:38 -0400
Date: Mon, 30 Jul 2007 16:20:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Guillaume Chazarain <guichaz@yahoo.fr>,
       Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1, spamassassin vs rpc stuffs, rpc 1, spamassassin 0
In-Reply-To: <46ADF2CB.4030200@zytor.com>
Message-ID: <Pine.LNX.4.64.0707301620210.26373@fbirervta.pbzchgretzou.qr>
References: <200707300957.39667.gene.heskett@gmail.com>
 <3d8471ca0707300704wc4119c2iaf865d685324d7c@mail.gmail.com> <46ADF2CB.4030200@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 30 2007 07:16, H. Peter Anvin wrote:
> Guillaume Chazarain wrote:
>> > Comments anyone?
>> 
>> This is not specific to the kernel.
>> It was discussed here: http://lkml.org/lkml/2007/1/24/258
>> http://cyberelk.net/tim/portreserve/ seems to be the solution,
>> it's a pity it is not widely deployed.
>> 
>
> The better solution probably would have bindresvport() in glibc be aware of a
> blacklist.

I am sure it already is.

16:21 ichi:/ws/iptables > l /etc/bindresvport.blacklist 
-rw-r--r-- 1 root root 332 Nov 25  2006 /etc/bindresvport.blacklist

But that may be a patch local to openSUSE.


	Jan
-- 
