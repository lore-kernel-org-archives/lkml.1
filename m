Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbXEUNrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbXEUNrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760901AbXEUNrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:47:33 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49581 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760815AbXEUNrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:47:31 -0400
Date: Mon, 21 May 2007 15:48:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix section mismatch warnings in mtrr
Message-ID: <20070521134828.GA1394@uranus.ravnborg.org>
References: <200705191443.27161.arvidjaar@mail.ru> <20070519133257.GB23370@uranus.ravnborg.org> <200705191555.49376.ak@suse.de> <4651A113.9020300@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4651A113.9020300@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 02:39:31PM +0100, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > On Saturday 19 May 2007 15:32, Sam Ravnborg wrote:
> >   
> >> Following section mismatch warnings were reported by Andrey Borzenkov:
> >>     
> >
> > In what configuration? I don't see this.
> 
> I'm pretty sure I made those functions __init when I cleaned up that
> code.  Did those pieces of the patch get mislayed?  I thought it made it
> into upstream.

There was another patch that removed the __init marker to _fix_ section mismatch errors.
I have lost the actual mail but I asked the submitter to send me a copy of
the configuration so I could take a closer look.
Obviously it was the wrong fix to remove the _init marker.

	Sam
