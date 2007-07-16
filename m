Return-Path: <linux-kernel-owner+w=401wt.eu-S1762635AbXGPUDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762635AbXGPUDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbXGPUDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:03:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35968 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbXGPUDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:03:40 -0400
Message-ID: <469BCF0C.6070109@garzik.org>
Date: Mon, 16 Jul 2007 16:03:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, jeremy@goop.org,
       jengelh@computergmbh.de, viro@ftp.linux.org.uk, nmiell@comcast.net,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: *at syscalls for xattrs?
References: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr> <20070715205313.GE21668@ftp.linux.org.uk> <1184534001.2765.5.camel@entropy> <20070715222323.GG21668@ftp.linux.org.uk> <Pine.LNX.4.64.0707160954160.25352@fbirervta.pbzchgretzou.qr> <469B2CAE.9010101@goop.org> <E1IAMWA-0004fM-00@dorka.pomaz.szeredi.hu> <469B3B73.9010400@zytor.com> <469B3EC2.8080702@garzik.org> <469BB190.1080300@zytor.com>
In-Reply-To: <469BB190.1080300@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeff Garzik wrote:
>>> What the *at() interfaces really do is fix/paper over a longstanding
>>> wart in Unix: the cwd really should have been a standard file descriptor
>>> (like stdin/stdout/stderr) instead of a magic piece of state maintained
>>> in kernel space.
>> It's more than a wart, IMO.  *at() allows one to close races (with
>> potential security implications) that are otherwise impossible to close,
>> in directory traversal.
>>
>> *at() permits a userspace program to hold proper references to all
>> objects during a directory traversal, with all that implies.
>>
> 
> Well, as Jeremy pointed out, in the absence of threads you can do the
> same thing with fchdir(), however, that's much more of a hack.

My posixutils project (coreutils replacement) used fchdir(2), but that 
still doesn't get you 100% race-free.  It gets you close, yes.

	Jeff



