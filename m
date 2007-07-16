Return-Path: <linux-kernel-owner+w=401wt.eu-S1762832AbXGPUoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762832AbXGPUoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbXGPUoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:44:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36150 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbXGPUoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:44:06 -0400
Message-ID: <469BD7B7.30009@zytor.com>
Date: Mon, 16 Jul 2007 13:40:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, jeremy@goop.org,
       jengelh@computergmbh.de, viro@ftp.linux.org.uk, nmiell@comcast.net,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: *at syscalls for xattrs?
References: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr> <20070715205313.GE21668@ftp.linux.org.uk> <1184534001.2765.5.camel@entropy> <20070715222323.GG21668@ftp.linux.org.uk> <Pine.LNX.4.64.0707160954160.25352@fbirervta.pbzchgretzou.qr> <469B2CAE.9010101@goop.org> <E1IAMWA-0004fM-00@dorka.pomaz.szeredi.hu> <469B3B73.9010400@zytor.com> <469B3EC2.8080702@garzik.org> <469BB190.1080300@zytor.com> <469BCF0C.6070109@garzik.org>
In-Reply-To: <469BCF0C.6070109@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>>
>> Well, as Jeremy pointed out, in the absence of threads you can do the
>> same thing with fchdir(), however, that's much more of a hack.
> 
> My posixutils project (coreutils replacement) used fchdir(2), but that
> still doesn't get you 100% race-free.  It gets you close, yes.
> 

I guess you're horked in the case where a single system call (e.g.
rename()) needs more than one pathname.  Yet another reason why a single
cwd isn't enough.

	-hpa
