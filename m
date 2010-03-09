Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab0CICTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:19:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756516Ab0CICTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:19:06 -0500
Date: Mon, 8 Mar 2010 18:18:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
In-Reply-To: <20100309020517.GT30031@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1003081811330.3669@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> <20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain> <4B9585BD.6070904@redhat.com>
 <alpine.LFD.2.00.1003081523280.3669@localhost.localdomain> <20100309001554.GP30031@ZenIV.linux.org.uk> <20100309004829.GQ30031@ZenIV.linux.org.uk> <alpine.LFD.2.00.1003081742380.3669@localhost.localdomain> <20100309020517.GT30031@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Mar 2010, Al Viro wrote:
> 
> Doesn't have to be a binding over /etc/passwd, BTW.  /etc as a mountpoint will
> serve just as well.

I agree. But I think more people are aware of a regular directory mount 
than about the ability to just mount a single file. So from a sneakyness 
standpoint, I like the "oh, btw, I just took over just the one file I care 
about" rather than trying to hide the whole directory.

Doesn't matter conceptually, though.

		Linus
