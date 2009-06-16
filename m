Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbZFPJoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbZFPJoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZFPJnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:43:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbZFPJnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:43:51 -0400
Date: Tue, 16 Jun 2009 11:43:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [BUG] [input] Sometimes mouse gets detected as PS2++ Logitech
 Mouse instead of ImPS/2 Logitech Wheel Mouse
In-Reply-To: <1244968510.5898.53.camel@mattotaupa.wohnung.familie-menzel.net>
Message-ID: <alpine.LNX.2.00.0906161142340.7457@wotan.suse.de>
References: <1244788506.6039.41.camel@mattotaupa.wohnung.familie-menzel.net>  <alpine.LRH.2.00.0906121649440.31685@twin.jikos.cz> <1244968510.5898.53.camel@mattotaupa.wohnung.familie-menzel.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Paul Menzel wrote:

> > [ added linux-input@ to CC ]
> Maybe the contact address in MAINTAINERS should be set to linux-input@?

I actually wanted to CC Dmitry as well, but forgot to do so.

> > > arbitrarily (I would say every two month) my Logitech Cordless MouseMan
> > > Wheel gets detected as (in dmesg)
> > > 
> > > PS2++ Logitech Mouse
> > > 
> > > instead of
> > > 
> > > ImPS/2 Logitech Wheel Mouse.
> > It would be nice if you could capture the dmesg output with i8042.debug 
> > command-line from the situation the mouse gets mis-detected. But I 
> > understand that with so low frequency of occurence, that would be a major 
> > pain.
> No problem. The problem has not yet surfaced again. But do I need to
> rebuild Linux or are those debug messages enough?

No rebuilding needed, just booting with i8042.debug is enough. Please 
provide us with the output once the bug triggers again.

Thanks,

-- 
Jiri Kosina
SUSE Labs
