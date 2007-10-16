Return-Path: <linux-kernel-owner+w=401wt.eu-S935164AbXJPS26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935164AbXJPS26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935126AbXJPS2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:28:18 -0400
Received: from mail.softservecom.com ([195.160.232.17]:43158 "EHLO
	mail.softservecom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935104AbXJPS2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:28:16 -0400
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Reply-To: vitalivanov@gmail.com
To: Willy Tarreau <w@1wt.eu>
Cc: zaitcev@redhat.com, gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, vitalivanov@gmail.com
In-Reply-To: <20071016154138.GA23326@1wt.eu>
References: <1192383445.8372.18.camel@dell1.softservecom.com>
	 <20071014182542.GA2832@1wt.eu>
	 <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
	 <20071014223921.GA4677@1wt.eu>
	 <1192542889.29039.66.camel@dell1.softservecom.com>
	 <20071016154138.GA23326@1wt.eu>
Content-Type: text/plain
Message-Id: <1192559051.29039.139.camel@dell1.softservecom.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-1) 
Date: Tue, 16 Oct 2007 21:24:11 +0300
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2007 18:24:11.0684 (UTC) FILETIME=[BFBCB640:01C81021]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-16 at 18:41, Willy Tarreau wrote:

> OK, I have no objection, but please apply the fixes the le16 problem as
> suggested by Pete and Greg first. Also, you will probably receive more
> comments, and/or criticisms from further reviews. This is normal and
> expected. You just have to fix your code so that it can be merged.

Done. Removed all le16_to_cpu's.
Comments are OK. Just a little bit busy on my regular work. So can give
responses not so quickly as you probably wanted. 

> > adutux is a simple Linux device driver for ADU boards from Ontrak Control Systems. 
> > The adutux driver exposes standard open/close/read/write API's to the user application.
> 
> If this is going to be the commit message, please reduce lines to less
> than 70 chars, and also enumerate the supportd devices and the one you
> performed the tests with. It helps a lot when users encounter problems.
> 

It's a driver description you asked for previously.

Commit message should look like this probably:
"Port of adutux driver from 2.6 kernel for Ontrak ADU boards."

Devices list:
As I said previously supported devices are:
http://www.ontrak.net/products.htm#Table%205
Just to list them here:
ADU100, ADU120, ADU130, ADU200, ADU208, ADU218.

Testing is performed on ADU200.
But command structure is identical for this devices and it is only
individual command syntax that varies between different ADU devices.

> Also, if you did not (I forgot to check), please ensure that the adutux
> maintainer in 2.6 is CC'd.

There is not maintainer for this device in 2.6.


Following Pete notes I will rework code and give it for review once again.
As I said it's usb-skeleton approach that I reused during the port.

Anyway, will get back to this soon.

Vitaliy

