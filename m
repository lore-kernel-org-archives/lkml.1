Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbYEaGwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbYEaGwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 02:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYEaGv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 02:51:57 -0400
Received: from senator.holtmann.net ([87.106.208.187]:57100 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbYEaGv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 02:51:56 -0400
Cc: David Woodhouse <dwmw2@infradead.org>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Michael Zappe <zapman@interlan.net>,
       Stephane Alnet <stephane@u-picardie.fr>,
       Brad Hards <bhards@bigpond.net.au>
Message-Id: <7D3DC891-CC9A-4CBD-8DCF-E684A2FB36B2@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080530164842.31b23848@core>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] kaweth: use request_firmware()
Date: Sat, 31 May 2008 08:51:38 +0200
References: <1211708969@pmac.infradead.org> <1212070841.26088.28.camel@shinybook.infradead.org> <200805301555.59327.oliver@neukum.org> <1212160598.8199.6.camel@shinybook.infradead.org> <FD896A2C-277F-45CF-AE26-E2E29DA8093F@holtmann.org> <20080530164842.31b23848@core>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

>> we tried to not put that policy into the drivers and I was looking
>> over this, but in the meantime driver slipped past me and made it in.
>> We should not do this at all and if people wanna have this, then they
>> should solve this within udev.
>
> Then you arrived at the party a year too late. The format name/ 
> firmware
> is commonly used all over the kernel. How that maps to a file or
> directory is indeed a matter for udev, but there is already a
> heirarchical namespace and pretending otherwise won't help.

I was not late to the party. I was the first one using  
request_firmware() and always keeping an eye on drivers using it and  
making sure using it correctly. However drivers sneaked in without  
that I realized it. Mainly because I don't have that hardware and  
reviewing every single driver obviously never happened.

I repeatedly said that no hierarchical namespace should be used (and  
this was a couple of years ago) and now since some developers misuse  
it, it makes it right. Don't think so.

Regards

Marcel

