Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYJUTSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYJUTSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbYJUTRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:17:48 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:59752 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbYJUTRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:17:45 -0400
Date: Tue, 21 Oct 2008 21:17:36 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Bryan Wu <Bryan.Wu@analog.com>
Subject: Re: [RFC] CRIS: Move header files from include to arch/cris
Message-ID: <20081021191736.GH24715@axis.com>
References: <20081021164211.GG24715@axis.com> <8bd0f97a0810211046n2e32868fu1a58cc9123da7c6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0810211046n2e32868fu1a58cc9123da7c6d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 07:46:18PM +0200, Mike Frysinger wrote:
> On Tue, Oct 21, 2008 at 12:42, Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> > That means that the machine dependent header files are moved to
> > arch/cris/mach-{fs,a3}/include, while the common and architecture
> > dependent files are moved to arch/cris/include.
> >
> > It is mainly this I'd like some input on, since most other ports
> > that have moved their header files have put all headers in arch/*/include.
> 
> that seems like a fairly obvious good idea to me ... i'm thinking we
> should do it for Blackfin as well ...

I'm still not decided, my main reason for following Blackfin and ARM
was that it seemed good to collect all mach-specific files in one place
in the tree.

However, keeping them in the same place makes it easy to grep through,
something I use quite frequently.


One thing that struck me just now is that the ARM and Blackfin
organization actually follows the way in how all header files have
been moved, i.e. that header files are being moved closer to the
source files that use them, in favor of collecting them all in one place...

> -mike

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
