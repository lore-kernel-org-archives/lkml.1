Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbYBELjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbYBELjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 06:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYBELjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 06:39:11 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34223 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYBELjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 06:39:09 -0500
References: <20080125180232.GA4613@kroah.com>
            <20080202123710.42df1aa0@weinigel.se>
            <20080202191930.GA19826@kroah.com>
            <47A5D9CD.5070001@davidnewall.com>
            <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com>
            <47A5E67D.9040804@davidnewall.com>
            <1202058820.15090.60.camel@violet>
In-Reply-To: <1202058820.15090.60.camel@violet>
From: David Newall <davidn@davidnewall.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David Newall <davidn@davidnewall.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Date: Tue, 05 Feb 2008 22:09:07 +1030
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <courier.47A84ADB.000047C1@hawking.rebel.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann writes:
> if a new drivers is originally written for Linux, then you are breaking
> the GPL.

Completely wrong.  However if the driver is distributed as built-in, then it 
would need to be licensed under GPL.  This means that a driver can be 
written and distributed as a module under any licence, proprietary or 
otherwise, presumably with the restriction that it may NOT be built-in. 

> You driver was meant to be
> running as Linux kernel module and thus it is derivative work.

It is precisely the fact that it is a loadable module, and does not form 
part of the kernel, that removes the requirement to distribute it under GPL. 


> What are you arguing here. It makes no difference if it is technical or
> not. The EXPORT_SYMBOL_GPL gives you a clear hint that when using this
> symbol, you have to obey to the GPL.

And that "hint" is a lie.
