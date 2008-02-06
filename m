Return-Path: <linux-kernel-owner+w=401wt.eu-S1761616AbYBFADQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761616AbYBFADQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 19:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757300AbYBFADA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 19:03:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50547 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756585AbYBFADA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 19:03:00 -0500
Date: Tue, 5 Feb 2008 16:02:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marcel Holtmann <marcel@holtmann.org>
cc: Jiri Kosina <jkosina@suse.cz>, David Sterba <dsterba@suse.cz>,
       linux-kernel@vger.kernel.org, Ben Martel <benm@symmetric.co.nz>,
       stephen@symmetric.co.nz
Subject: Re: [PATCH][v4] ipwireless: driver for 3G PC Card
In-Reply-To: <1202255212.15090.180.camel@violet>
Message-ID: <alpine.LFD.1.00.0802051600330.2967@woody.linux-foundation.org>
References: <20080201153707.GA24859@ds.suse.cz>  <Pine.LNX.4.64.0802051114390.30955@jikos.suse.cz> <1202255212.15090.180.camel@violet>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Feb 2008, Marcel Holtmann wrote:
> 
> I had some minor additional questions, but in general, I second that
> this driver should be merged for 2.6.25.
> 
> The question of the PCMCIA maintainership came up on a different mailing
> list.

Well, in the case of this particular driver, I think it's not so much a 
PCMCIA thing as a "network driver" thing. It's not like the driver 
actually needs any extra PCMCIA support or anything like that, and as such 
I think in this case it's really more of a regular network driver than 
anything else.

And especially with wireless, I think the impact for any future changes 
are about the wireless infrastructure, not PCMCIA. There's little reason 
to believe that we'll ever make any big PCMCIA overhauls exctly because 
PCMCIA is so dead.

So I'd happily merge it, but I would be even happier if I got ack's from 
the wireless people or if it was simply merged that way too.

			Linus
