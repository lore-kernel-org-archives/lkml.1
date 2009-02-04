Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbZBDQwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbZBDQwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZBDQvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:51:50 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:36837 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbZBDQvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:51:49 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 4 Feb 2009 08:51:26 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Christoph Hellwig <hch@lst.de>
cc: Jonathan Corbet <corbet@lwn.net>,
       Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com,
       dada1@cosmosbay.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       andi@firstfloor.org, oleg@redhat.com, viro@ZenIV.linux.org.uk,
       David Miller <davem@davemloft.net>, linux-api@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
In-Reply-To: <20090204071320.GA19348@lst.de>
Message-ID: <alpine.DEB.1.10.0902040849570.5477@alien.or.mcafeemobile.com>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net> <1233598811-6871-3-git-send-email-corbet@lwn.net> <20090203133942.2ecec281.akpm@linux-foundation.org> <4988BD4E.8080206@cosmosbay.com> <20090203140543.6e915f97.akpm@linux-foundation.org>
 <1233699722.3243.127.camel@calx> <20090203153740.363d0a04@bike.lwn.net> <20090203145346.8df40277.akpm@linux-foundation.org> <20090203161931.4054a25e@bike.lwn.net> <20090204071320.GA19348@lst.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Christoph Hellwig wrote:

> On Tue, Feb 03, 2009 at 04:19:31PM -0700, Jonathan Corbet wrote:
> >  1) Use i_lock to protect accesses to f_flags.  This would enable some 
> >     BKL usage to be removed, but would not fix fasync.
> 
> What about just turning f_ep_lock into f_lock and using it?

Looks like a good idea.


- Davide


