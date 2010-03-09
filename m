Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab0CICFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:05:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43968 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab0CICFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:05:39 -0500
Date: Tue, 9 Mar 2010 02:05:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
Message-ID: <20100309020517.GT30031@ZenIV.linux.org.uk>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
 <20100308094647.GA14268@elte.hu>
 <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
 <4B9585BD.6070904@redhat.com>
 <alpine.LFD.2.00.1003081523280.3669@localhost.localdomain>
 <20100309001554.GP30031@ZenIV.linux.org.uk>
 <20100309004829.GQ30031@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1003081742380.3669@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003081742380.3669@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 05:49:10PM -0800, Linus Torvalds wrote:

> That's a good point, btw, and shows one conceptual difference between 
> content-based and pathname-based rules.
> 
> For example, if you want to log any changes to "/etc/passwd" (which is 
> something pretty reasonable to do at least conceptually), what about doing 
> a bind mount on top of that file?

Doesn't have to be a binding over /etc/passwd, BTW.  /etc as a mountpoint will
serve just as well.
