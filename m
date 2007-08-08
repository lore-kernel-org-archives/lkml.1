Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbXHHLw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbXHHLw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 07:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbXHHLwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 07:52:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59087 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXHHLwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 07:52:21 -0400
Date: Wed, 8 Aug 2007 13:52:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] msleep() with hrtimers
Message-ID: <20070808115219.GA13878@one.firstfloor.org>
References: <15327.1186166232@lwn.net> <20070807124009.9f6c2247.akpm@linux-foundation.org> <p73ps1ys0jz.fsf@bingen.suse.de> <1a297b360708080409tfc9dee5mb92c216919bffc1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a297b360708080409tfc9dee5mb92c216919bffc1e@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 03:09:14PM +0400, Manu Abraham wrote:
> On 08 Aug 2007 13:55:28 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> > Andrew Morton <akpm@linux-foundation.org> writes:
> > >
> > > I'd be surprised if there was significant overhead - the maximum frequency
> > > at which msleep() can be called is 1000Hz.  We'd need an awful lot of
> > > overhead for that to cause problems, surely?
> >
> > The bigger risk is probably to break drivers that rely on msleep(1)
> > really being msleep( very long depending on HZ )
> >
> > But the only way to find out is to try it.
> 
> Well, i am quite sure a lot of drivers will be broken. But well .. if

If you know of specific examples you should list them so that
they can be fixed proactively.

-Andi
