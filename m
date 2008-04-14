Return-Path: <linux-kernel-owner+w=401wt.eu-S1760973AbYDNOtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973AbYDNOtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYDNOs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:48:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbYDNOs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:48:58 -0400
Date: Mon, 14 Apr 2008 07:48:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] F_GETPATH for linux
In-Reply-To: <20080414061958.GA21202@infradead.org>
Message-ID: <alpine.LFD.1.00.0804140742380.2820@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0804131455030.12741@alien.or.mcafeemobile.com> <20080414061958.GA21202@infradead.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Apr 2008, Christoph Hellwig wrote:
> 
> Adding a duplicated API like this is rather pointless.  Especially as
> the readlink is easier and makes more sense.

Well, I wouldn't say "makes more sense". It may be more traditional (for 
Linux), but it has its problems, notably performance. One use of F_GETPATH 
is for server code, to check that a previous open() didn't follow symlinks 
to outside of some specified area.

Not that I like F_GETPATH much either, but portability is a strong enough 
argument that coming up with some *other* way is probably not great.

			Linus
