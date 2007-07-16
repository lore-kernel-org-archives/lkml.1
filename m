Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbXGPSCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbXGPSCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbXGPSB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:01:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbXGPSBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:01:24 -0400
Message-ID: <469BB190.1080300@zytor.com>
Date: Mon, 16 Jul 2007 10:57:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, jeremy@goop.org,
       jengelh@computergmbh.de, viro@ftp.linux.org.uk, nmiell@comcast.net,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: *at syscalls for xattrs?
References: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr> <20070715205313.GE21668@ftp.linux.org.uk> <1184534001.2765.5.camel@entropy> <20070715222323.GG21668@ftp.linux.org.uk> <Pine.LNX.4.64.0707160954160.25352@fbirervta.pbzchgretzou.qr> <469B2CAE.9010101@goop.org> <E1IAMWA-0004fM-00@dorka.pomaz.szeredi.hu> <469B3B73.9010400@zytor.com> <469B3EC2.8080702@garzik.org>
In-Reply-To: <469B3EC2.8080702@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>>
>> What the *at() interfaces really do is fix/paper over a longstanding
>> wart in Unix: the cwd really should have been a standard file descriptor
>> (like stdin/stdout/stderr) instead of a magic piece of state maintained
>> in kernel space.
> 
> It's more than a wart, IMO.  *at() allows one to close races (with
> potential security implications) that are otherwise impossible to close,
> in directory traversal.
> 
> *at() permits a userspace program to hold proper references to all
> objects during a directory traversal, with all that implies.
> 

Well, as Jeremy pointed out, in the absence of threads you can do the
same thing with fchdir(), however, that's much more of a hack.

	-hpa
