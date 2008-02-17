Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYBQT0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYBQT0Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYBQT0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:26:16 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46497 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbYBQT0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:26:16 -0500
Date: Sun, 17 Feb 2008 20:26:25 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, ak@suse.de, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86: lds - Use THREAD_SIZE instead of numeric constant
Message-ID: <20080217192625.GG14588@uranus.ravnborg.org>
References: <20080217151716.274134094@gmail.com> <20080217151925.402628615@gmail.com> <20080217185936.GB14588@uranus.ravnborg.org> <20080217190829.GJ19263@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217190829.GJ19263@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 08:08:29PM +0100, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Sun, Feb 17, 2008 at 06:17:18PM +0300, Cyrill Gorcunov wrote:
> > > Though we use PDA for regular task stack but that
> > > is not acceptable for init_task wich is special
> > > one. We still have to allocate init_task's stack
> > > in that manner.
> > 
> > hpa had some comments about this particular alignment. If we keep the 
> > alignmnet then Cyrill's patch looks good.
> 
> ok. I've picked up Cyrill's cleanup - can i add your acked-by line?
Yes - I should have been specific and not just said "looks good".
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
