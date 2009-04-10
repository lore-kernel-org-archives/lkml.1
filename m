Return-Path: <linux-kernel-owner+w=401wt.eu-S935684AbZDJLpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935684AbZDJLpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760871AbZDJLpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:45:15 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56761 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761521AbZDJLpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:45:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=efXY07CSIIocGW3L15yxWh6P7mftp0uRCIl9ofOmlvHwoscg17B6VH4aIExXYpDa0+
         0GfU4OZv0yFCyXlkr7dF9kJeTL4qESo1i6+DmqjXpNUHoyyS2uDlcZY0nSO1P6SLZBaZ
         PeoGoYX84vZcKueV5vn3UpIFs7oFGwESER5H4=
Date: Fri, 10 Apr 2009 15:45:16 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
Message-ID: <20090410114516.GA3500@x200.localdomain>
References: <20090410023207.GA27788@x200.localdomain> <20090410082815.GA17962@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410082815.GA17962@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 10:28:15AM +0200, Ingo Molnar wrote:
> 
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > This is to show how we see C/R and to provoke discussion on number 
> > of important issues (mounts, ...).
> > 
> > This is small part of long-awaited to be cleanuped code.
> > 
> > It's able to restore busyloop on i386 and x86_64 and restore i386 
> > busyloop on x86_64. It wasn't tested much more than that.
> > 
> > I'm currently starting formal testsuite, otherwise it's 
> > whack-a-mole game and formal TODO list (a huge one).
> 
> One simple patch-submission request: if you start sending large 
> series of patches then please post it like others do: by using 
> git-format-patch or some other tool that preserves the threading of 
> the discussion and links all the 1/30..30/30 patches back to the 
> 0/30 mail.
> 
> This submission has created 31 separate threads on lkml, intermixed 
> with other threads - making it more difficult to review it as a 
> coherent unit.

OK, I thought stgit will screw something, so sent it old proven way :-\
