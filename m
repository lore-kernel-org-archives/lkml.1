Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0CHSpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 13:45:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51506 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab0CHSpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 13:45:36 -0500
Date: Mon, 8 Mar 2010 18:45:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
Message-ID: <20100308184521.GK30031@ZenIV.linux.org.uk>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
 <20100308094647.GA14268@elte.hu>
 <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 10:08:31AM -0800, Linus Torvalds wrote:

> In other words: it really _does_ make more sense to say "this process has 
> rights to overwrite the path '/etc/passwd'" than it does to try to label 
> the file. The _fundamental_ rule is about the pathname. The labeling comes 
> about BECAUSE YOU USED A HAMMER FOR A SCREW.
> 
> I really don't understand why some people are unable to admit this fact. 

Because you don't have to use that pathname to modify the bits returned
by read() after open() on that pathname?

I'm not fond of selinux, to put it mildly, but "pathname-based" stuff simply
doesn't match how the pathname resolution is defined on Unix...
