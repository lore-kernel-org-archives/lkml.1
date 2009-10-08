Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbZJHOzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbZJHOzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 10:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932411AbZJHOzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 10:55:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932409AbZJHOzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 10:55:10 -0400
Date: Thu, 8 Oct 2009 07:54:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: James Bottomley <James.Bottomley@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
In-Reply-To: <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain>
References: <1254844007.4383.85.camel@mulgrave.site>  <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>  <1254862442.4383.183.camel@mulgrave.site> <1255012399.4187.24.camel@mulgrave.site> <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Oct 2009, Linus Torvalds wrote:
> 
> I'm taking it (and the parisc one I was also unhappy with)

Actually, looking at it again, I'm wavering.

That BFA driver isn't a "driver". It's a huge subsystem of it's own. It's 
almost 50 _thousand_ lines of code for just a single "driver", and for 
rare hardware at that.

Quite frankly, the "bang per line" is almost zero. 

What the ^&@* is wrong with "enterprise SCSI" people? The amount of crazy 
is overwhelming.

So I've pulled it, but I'm still considering just unpulling it. That 
driver is _not_ "just a driver".  It's something more. Something dank and 
smelly, that has grown in dark and forbidding places.

The whole crazy "high end SCSI" industry needs a f*cking exorcism.

Even if I don't unpull, I don't _ever_ want to see a driver like this 
outside the merge window. And dammit, James, you should have realized 
that.

			Linus
