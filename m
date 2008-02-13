Return-Path: <linux-kernel-owner+w=401wt.eu-S933929AbYBMRQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929AbYBMRQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933226AbYBMRQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:16:10 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:57374 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821AbYBMRQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:16:08 -0500
Date: Wed, 13 Feb 2008 18:16:14 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, pageexec@freemail.hu,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: vmsplice exploits, stack protector and Makefiles
Message-ID: <20080213171614.GA12259@uranus.ravnborg.org>
References: <20080212090001.3fcc4ca0@laptopd505.fenrus.org> <47B30F05.29637.9A21F9B@pageexec.freemail.hu> <alpine.LFD.1.00.0802130749210.2920@woody.linux-foundation.org> <20080213160148.GA20241@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213160148.GA20241@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 05:01:48PM +0100, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > if you're merging this, please do the independent parts really 
> > independenrly. For example, the above is a patch in its own right, and 
> > probably worth doing regardless of anything else.
> 
> yes. I wanted to have it tested for a bit, because the lack of use of 
> the gcc flag means complete lack of testing coverage. The obligatory 
> "please add a stackprotector self-test" debug feature request went to 
> Arjan two days ago already.

Do you think that the top-lvel Makefile change is OK to merge?
I would like to merge it separatly to have maximum bisectability.

	Sam
