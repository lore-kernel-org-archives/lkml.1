Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbXCEEN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbXCEEN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbXCEEN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:13:27 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:40757 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbXCEEN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:13:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=X+nzF64FOvWRWsXj4RcvBo+f9wygS7td7/NI7Lz+Lw5X6p+MSUjpsmGzeVR5qxvLlzDvs6U/dJtLgT07iq0oqDT6kOBjRBYQruoBimHFryUdR6mfJEurTa11RSakxTKJtz5t7WEkfbOsSlxYiniA6aXA++uRGFshL+1/07+AlOc=
Message-ID: <45EB98E4.9070307@gmail.com>
Date: Mon, 05 Mar 2007 13:13:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Dale Blount <linux-kernel@dale.us>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: sata_sil problems with recent kernels
References: <1172250027.15179.16.camel@dale.velocity.net>	 <1172602444.5420.17.camel@dale.velocity.net> <1172698758.30931.18.camel@dale.velocity.net>
In-Reply-To: <1172698758.30931.18.camel@dale.velocity.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dale Blount wrote:
> On Tue, 2007-02-27 at 13:54 -0500, Dale Blount wrote:
>> On Fri, 2007-02-23 at 12:00 -0500, Dale Blount wrote:
>>> Hi,
>>>
>>> Excuse me if this has been covered or fixed, I couldn't find anything in
>>> the archives.
>>>
>>> I upgraded from 2.6.11.7 to 2.6.20.1 today and found all the drives
>>> connected to 2 brands of sata_sil sata controllers not working.  The
>>> drives are also (now) of various brands, Maxtor 300GB and 500GB
>>> Seagates.
> 
> For the archives, the fix is documented here:
> 
> http://article.gmane.org/gmane.linux.ide/16304

Yeap, that's the correct fix and the problem is introduced in 2.6.20 by
using polling IDENTIFY by default.  Well, the bug has always been there
but no one was issuing polling command to sata_sil upto 2.6.19.

This will probably included in the next -stable iteration.  Thanks.

-- 
tejun
