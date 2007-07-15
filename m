Return-Path: <linux-kernel-owner+w=401wt.eu-S1760734AbXGOXN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbXGOXN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759372AbXGOXNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:13:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40034 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758572AbXGOXNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:13:07 -0400
Message-ID: <469AA90C.8080105@zytor.com>
Date: Sun, 15 Jul 2007 16:09:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Nicholas Miell <nmiell@comcast.net>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: *at syscalls for xattrs?
References: <Pine.LNX.4.64.0707132228460.25352@fbirervta.pbzchgretzou.qr> <20070715205313.GE21668@ftp.linux.org.uk> <1184534001.2765.5.camel@entropy> <20070715222323.GG21668@ftp.linux.org.uk>
In-Reply-To: <20070715222323.GG21668@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> 
>>>> BTW, why is fstatat called fstatat and not statat? (Same goes for 
>>>> futimesat.) It does not take a file descriptor for the file argument. 
>>>> Otherwise we'd also need fopenat/funlinkat, etc. Any reasons?
>>> Ulrich having an odd taste?
>> Solaris compatibility.
> 
> "Sun having no taste whatsoever"

Yup.  I filed an objection to this with the POSIX committee, but it was
rejected :(

	-hpa
