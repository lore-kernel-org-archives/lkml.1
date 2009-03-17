Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbZCQNlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbZCQNlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 09:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbZCQNl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:41:29 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:2173 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbZCQNl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:41:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qbef3vXmgW8ZZ19FT6agjzEjq1JYcYbhBqt7eJQvugqY0KWJrRRWl/0yTUiE2hKqsc
         mEdpQ+5fhCiXE2SPqNkhHsNWMqujnwfj7QBPnvnpikPVxJm2HKsWCPjneWMZJXAyGPbG
         AvbFx55Nzm5/jZocUBxBzeciVgNPW1N9XLciU=
Date: Tue, 17 Mar 2009 16:48:37 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Zhang Le <r0bertz@gentoo.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [PATCH] filp->f_pos not correctly updated in proc_task_readdir
Message-ID: <20090317134837.GB3907@x200.localdomain>
References: <1237185871-3343-1-git-send-email-r0bertz@gentoo.org> <20090316083457.GV28946@ZenIV.linux.org.uk> <20090317103744.GA2399@x200.localdomain> <20090317125346.GA22268@adriano.hkcable.com.hk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317125346.GA22268@adriano.hkcable.com.hk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 08:53:47PM +0800, Zhang Le wrote:
> > fs/built-in.o: In function `proc_task_readdir':
> > compr_zlib.c:(.text+0x434b8): undefined reference to `__cmpdi2'
> > compr_zlib.c:(.text+0x434d4): undefined reference to `__cmpdi2'
> 
> Hi, I am sorry but I can't reproduce this.

It's on arm, I fixed it up already.
