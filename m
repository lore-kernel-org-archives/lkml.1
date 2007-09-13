Return-Path: <linux-kernel-owner+w=401wt.eu-S1765088AbXIMG3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765088AbXIMG3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 02:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbXIMG3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 02:29:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39304 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbXIMG3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 02:29:22 -0400
Date: Thu, 13 Sep 2007 08:29:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: hooanon05@yahoo.co.jp
cc: Al Boldi <a1426z@gawab.com>, bharata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, Jan Blunck <jblunck@suse.de>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [RFC] Union Mount: Readdir approaches 
In-Reply-To: <E1IVhcx-0000qV-V0@jroun>
Message-ID: <Pine.LNX.4.64.0709130829030.22122@fbirervta.pbzchgretzou.qr>
References: <20070907054618.GD1692@in.ibm.com>
 <Pine.LNX.4.64.0709122024500.22467@fbirervta.pbzchgretzou.qr>
 <E1IVeEx-0000rJ-1R@jroun> <200709130832.09330.a1426z@gawab.com>
 <E1IVhcx-0000qV-V0@jroun>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 13 2007 14:52, hooanon05@yahoo.co.jp wrote:
>Al Boldi:
>> It turns out that the problem was this in dentry.c:
>	:::
>> Commenting the #if block makes it compile now.
>> 
>> Works great too.  Even performance wise.  Needs more testing though.
>
>Thank you for your report and forwarding your original message.
>And I am glad that it is working for you.
>
>It seems that '#if ... #endif' in an 'unlikly' macro argument is bad
>coding. I don't know why my compiler and other users compiler didn't
>produce an error.

http://lkml.org/lkml/2007/8/5/249 might be related.



	Jan
-- 
