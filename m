Return-Path: <linux-kernel-owner+w=401wt.eu-S1762610AbXEUNti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762610AbXEUNti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762018AbXEUNta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:49:30 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53599 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761512AbXEUNt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:49:29 -0400
Date: Mon, 21 May 2007 15:50:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix section mismatch warnings in mtrr
Message-ID: <20070521135023.GB1394@uranus.ravnborg.org>
References: <200705191443.27161.arvidjaar@mail.ru> <20070519133257.GB23370@uranus.ravnborg.org> <200705191555.49376.ak@suse.de> <4651A113.9020300@goop.org> <20070521134828.GA1394@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521134828.GA1394@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 03:48:28PM +0200, Sam Ravnborg wrote:
> On Mon, May 21, 2007 at 02:39:31PM +0100, Jeremy Fitzhardinge wrote:
> > Andi Kleen wrote:
> > > On Saturday 19 May 2007 15:32, Sam Ravnborg wrote:
> > >   
> > >> Following section mismatch warnings were reported by Andrey Borzenkov:
> > >>     
> > >
> > > In what configuration? I don't see this.
> > 
> > I'm pretty sure I made those functions __init when I cleaned up that
> > code.  Did those pieces of the patch get mislayed?  I thought it made it
> > into upstream.
> 
> There was another patch that removed the __init marker to _fix_ section mismatch errors.
> I have lost the actual mail but I asked the submitter to send me a copy of
It was this patch that removed the __init markers:
http://lkml.org/lkml/2007/5/11/161

	Sam
