Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbYDNLzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbYDNLzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 07:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYDNLzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 07:55:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42432 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbYDNLzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 07:55:20 -0400
Message-ID: <480343B0.9030505@zytor.com>
Date: Mon, 14 Apr 2008 04:44:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] F_GETPATH for linux
References: <Pine.LNX.4.64.0804131455030.12741@alien.or.mcafeemobile.com> <20080414061958.GA21202@infradead.org>
In-Reply-To: <20080414061958.GA21202@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sun, Apr 13, 2008 at 03:00:53PM -0700, Davide Libenzi wrote:
>> I was working on some bsd/linux compatibility code, and I noticed that we 
>> do not have F_GETPATH. I know we can readlink /proc/PID/fd/FD (that is 
>> what I'm doing now, under #ifdef), but I gave a patch a shot anyway.
>> Here it is, building but untested ...
> 
> Adding a duplicated API like this is rather pointless.  Especially as
> the readlink is easier and makes more sense.

Yes; also, using /proc/self/fd/... makes it a little easier.

	-hpa
