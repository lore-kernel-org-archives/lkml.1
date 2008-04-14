Return-Path: <linux-kernel-owner+w=401wt.eu-S1763107AbYDNRfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763107AbYDNRfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYDNRfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:35:07 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:41618 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbYDNRfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:35:06 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 14 Apr 2008 10:34:16 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Christoph Hellwig <hch@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] F_GETPATH for linux
In-Reply-To: <20080414061958.GA21202@infradead.org>
Message-ID: <Pine.LNX.4.64.0804141030060.20665@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0804131455030.12741@alien.or.mcafeemobile.com>
 <20080414061958.GA21202@infradead.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Christoph Hellwig wrote:

> On Sun, Apr 13, 2008 at 03:00:53PM -0700, Davide Libenzi wrote:
> > I was working on some bsd/linux compatibility code, and I noticed that we 
> > do not have F_GETPATH. I know we can readlink /proc/PID/fd/FD (that is 
> > what I'm doing now, under #ifdef), but I gave a patch a shot anyway.
> > Here it is, building but untested ...
> 
> Adding a duplicated API like this is rather pointless.  Especially as
> the readlink is easier and makes more sense.

As I said, we can do it in the other way. I struck this one when trying to 
work out (read port) some BSD code to Linux. IMO, given that the patch 
does virtually only add an F_GETPATH define in fcntl.h, and a case in the 
fcntl switch, it may be worth considering.



- Davide


