Return-Path: <linux-kernel-owner+w=401wt.eu-S1751192AbXBRN50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbXBRN50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 08:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbXBRN50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 08:57:26 -0500
Received: from thunk.org ([69.25.196.29]:60146 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbXBRN50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 08:57:26 -0500
Date: Sun, 18 Feb 2007 08:57:19 -0500
From: Theodore Tso <tytso@mit.edu>
To: Trent Waddington <trent.waddington@gmail.com>
Cc: "Michael K. Edwards" <medwards.linux@gmail.com>,
       Neil Brown <neilb@suse.de>, davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070218135719.GB20321@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Trent Waddington <trent.waddington@gmail.com>,
	"Michael K. Edwards" <medwards.linux@gmail.com>,
	Neil Brown <neilb@suse.de>, davids@webmaster.com,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
References: <20070216125353.GN13958@stusta.de> <MDEHLPKNGKAHNMBLJOLKKEIMBKAC.davids@webmaster.com> <17878.48376.629016.49202@notabene.brown> <f2b55d220702171855u59e3cc47i73e4aa48d0c0968c@mail.gmail.com> <3d57814d0702171926v53812baeqaeeda326aa225acf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d57814d0702171926v53812baeqaeeda326aa225acf@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 01:26:47PM +1000, Trent Waddington wrote:
> Such a strange attitude.. to go to all this effort to quote carefully
> and correctly one set of people and to then total misconstrue the
> words of another.
> 
> The FSF's argument in regards to readline is that you may not
> distribute readline with proprietary software linked to it.  They
> don't claim they "0wn" your source code.

Actually, the FSF and many of its representatives, has claimed, on
many occassions, that the GPL infects across dynamic linking.  That
is, if you write your own code that calls readline which links via a
dynamically linked shared library, and perhaps even across dlopen(),
they claim that the GPL applies to the code which you write.  Given
that the only way this could happen is via copyright law, they are
basically saying that if you use the readline interface, you have
created a derived work and they therefore 0wn your source code.

Whether or not this would be laughed out of court or not will very
much depend on the local legal precedents (and Trent Waddington has
quoted some very interesting legal cases based on US court decisions,
including an entertaining brief written by Eben Moglen decrying
interface copyrights which on the surface seems to go against
everything else the FSF has said since the Lotus case), but the
kernel-mailing list isn't the place to debate how law can be applied
to facts, or whether or not Eben Moglen is a hypocrite or not.

So can we please stop now?  I doubt anyone is going to be able to
convince anyone else on this matter; people's opinions are pretty well
formed by now, and until someone chooses to litigate on this specific
point about whether or not the GPL (v2 or v3) can infect across a
dynamic link in various jurisdictions, we're not going to settle it here.

Regards,

						- Ted
