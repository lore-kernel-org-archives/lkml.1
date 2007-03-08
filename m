Return-Path: <linux-kernel-owner+w=401wt.eu-S1030234AbXCHIPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030234AbXCHIPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030228AbXCHIPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:15:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:58332 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030227AbXCHIPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:15:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LnIs13WPv1NVq7ADEiItGW+WDrOoqNFU7HI3WDPWb159X2iTnVdeOnEPyQELk4L1n8e9hHDI1TkWSAktN2eSA2VxKW9wIbSleXBkdetpzQF22a2TVOOdkJkLuo27YbWTDZHbUzsh8N/Sw41VmhtxdF/1zVL/Vo4gCliB95RTc8E=
Message-ID: <df9815e70703080015o2cd2dffelc36abfc76278f122@mail.gmail.com>
Date: Thu, 8 Mar 2007 16:15:34 +0800
From: albcamus <albcamus@gmail.com>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: RE: Linux v2.6.20-rc5
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Andrew Morton" <akpm@osdl.org>, "Linus Torvalds" <torvalds@osdl.org>
In-Reply-To: <b6a2187b0701140546ne0b95d8q7aff70d93ffabb9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0701141858490.7122@boston.corp.fedex.com>
	 <20070114125648.GV7469@stusta.de>
	 <b6a2187b0701140546ne0b95d8q7aff70d93ffabb9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I guess that it is because 'paravirt_ops' was exported as GPL symbol, whereas
the vmware module doen't declare any license.

I tried to add the following line:

MODULE_LICENSE("GPL");

into vmmon.tar and vmnet.tar under /usr/lib/vmare/modules/source/,
then it works.
 (but maybe will tear the copyright by VMWare Inc.)

my kernel: 2.6.21-rc3 with CONFIG_PARAVIRT=y

>2007/1/14, Jeff Chua <jeff.chua.linux@gmail.com>:

> I recompiled the vmmon module under the new kernel with
> CONFIG_PARAVIRT=y. It compiled fine, but when loaded, it gives the
> unknown symbol warning. I shalll make it clear that this is not a
> kernel issue ... it's just vmware, but I don't know how to fix it, and
> needed help from the experts.
>
> Thanks,
> Jeff.
