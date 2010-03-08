Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0CHTA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:00:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251Ab0CHTAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:00:22 -0500
Date: Mon, 8 Mar 2010 10:59:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
In-Reply-To: <20100308184521.GK30031@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1003081051130.3989@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> <20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain> <20100308184521.GK30031@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Mar 2010, Al Viro wrote:
> > 
> > I really don't understand why some people are unable to admit this fact. 
> 
> Because you don't have to use that pathname to modify the bits returned
> by read() after open() on that pathname?

The thing is, I don't think it's an "either or".

Sure, there is content security. Nobody disputes that. The security 
decision about how to open a file is about the contents of the file.

So I'm not suggesting we _replace_ content-based security with 
pathname-based security. I'm just saying that pathnames actually do matter 
for security, and that they are an independent issue.

> I'm not fond of selinux, to put it mildly, but "pathname-based" stuff simply
> doesn't match how the pathname resolution is defined on Unix...

Again, I'm not claiming that we should change how "open" works and has 
always worked. I don't even understand why you have that crazy "either or" 
mentality to begin with. Why?

It's not "either pathname or inode". I'm saying _both_ make sense. 

In some situations, the name itself really is what is fundamentally 
special about the file.

		Linus
