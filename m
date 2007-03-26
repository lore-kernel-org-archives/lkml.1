Return-Path: <linux-kernel-owner+w=401wt.eu-S933629AbXCZGsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbXCZGsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 02:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933635AbXCZGsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 02:48:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:50193 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933629AbXCZGsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 02:48:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=aztvsMlXBP5JUQ0B+KHtQIldE9Gur05ST/GOGmcUMplO28YZ1NSRle8aWHzQE1zr9rNqwfeW/sHMF3cafjkT8VmJy2VBH+wHKjLZJyr9Pgj8KSTOYy0nxLomlSZCl2UG+j9YYFuN5RFFrrr3K4wyqALJ0+Rd0G7Rm9Hh1oMplio=
Message-ID: <46076CB8.9000005@gmail.com>
Date: Mon, 26 Mar 2007 10:48:24 +0400
From: Sergey Smirnov <svs1957@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: HELP!!! SD and suspend damage i-node.
References: <4602781C.9060804@gmail.com> <20070323225820.GA5121@ucw.cz>
In-Reply-To: <20070323225820.GA5121@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend damage filesystem each times on 4G SD.
I use bluetooth. But corruption doesn't depend on it.
I also test 2.6.21-rc4-git7 kernel. The same problem.
512Mb SD works normal.
Pavel Machek wrote:
> Hi!
> 
>> I use 2.6.20.2 kernel with ext3 rootfs on 4Gb SD on sharp zaurus sl-750 (PXA255).
>> After suspend/resume filesystem stay clean. But some i-nodes become broken.
>> Some files looks like block device or pipe with strange permissions, owner etc.
>> I'm sure that there is no bad blocks on SD.
>> I'll send any additional information. Just say me what you need to help me.
>> I had i lot of tries. Apply patches, remove its, change fstype etc.
>> output of fsck -f
> 
> How repeatable is the corruption? I have c3000 here, and it corrupts
> memory during system, say during one in 5 suspends. Longer suspends
> seem to lead to 'more' corruption.
> 
> It did not damage my filesystem, yet.
> 
> Do you use bluetooth?

