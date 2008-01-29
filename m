Return-Path: <linux-kernel-owner+w=401wt.eu-S1763496AbYA2P3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763496AbYA2P3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbYA2P3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:29:23 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:57220 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbYA2P3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:29:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ZI0q6novTTDDBW4q59QE6BYyLE+4460EhUHEaUWesIzYai2MvnIGTp1t+CRkfnelNtxGbQ6CShSiTueW5ZxqY9Z6X17cLGCLZFG0alRly6xJRTpw41fj6mTNndfQGyCoQ+hPJAF3yCSSboitCSV7hT+A73qqovtAxMBfy5cL0C0=
Message-ID: <479F464D.7050603@gmail.com>
Date: Tue, 29 Jan 2008 16:29:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Yoav Artzi <yoavar@checkpoint.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Sending IOCTLs from 32-bit userland to 64-bit Kernel module
References: <479F278D.3010905@checkpoint.com>
In-Reply-To: <479F278D.3010905@checkpoint.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2008 02:18 PM, Yoav Artzi wrote:
> Thanks. I am aware of these issues and we already have a pretty capable 
> layer to deal with these issues (unfortunately, it was very necessary). 
> My problem is not with the data carried by the IOCTL, but with IOCTL 
> command code itself, which comes out wrong on the kernel side. And my 
> problem is not only in the size data, but also in other fields.
> 
> IOCTL command code:
> 
> 1 byte: W/R/RW                                       -------- Passes 
> through fine
> 
> 1 byte: size of data carried                         -------- DOESN'T 
> PASS THROUGH
> 
> 1 byte: identifier character of the module   -------- Passes through fine
> 
> 1 byte: IOCTL number                               -------- DOESN'T PASS 
> THROUGH
> 
> 
> The funny thing is that I always get the same IOCTL command code on the 
> kernel side, no matter what I send using the ioctl() system call.
> 
> 
> Any idea?

Please show us your code with ioctls implemented both in kernel and userspace. 
And the definitions and fops aswell. Without it it's very hard to say what's 
going wrong.
