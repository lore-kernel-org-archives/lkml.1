Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbXFPUjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbXFPUjs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 16:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbXFPUjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 16:39:39 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:49543 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbXFPUji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 16:39:38 -0400
Date: Sat, 16 Jun 2007 16:39:26 -0400
To: "Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com>
Cc: Jack Stone <jack@hawkeye.stone.uk.eu.org>, alan <alan@clueserver.org>,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070616203926.GG14788@delft.aura.cs.cmu.edu>
Mail-Followup-To: "Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com>,
	Jack Stone <jack@hawkeye.stone.uk.eu.org>,
	alan <alan@clueserver.org>, hpa@zytor.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@zeniv.linux.org.uk
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <46739B2C.4080606@hawkeye.stone.uk.eu.org> <4673B15B.2080300@wolfmountaingroup.com> <4673B77E.1000803@wolfmountaingroup.com> <20070616164931.GF14788@delft.aura.cs.cmu.edu> <46744225.7000609@wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46744225.7000609@wolfmountaingroup.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 02:03:49PM -0600, Jeffrey V. Merkey wrote:
> Jan Harkes wrote:
> >implementation, just a high level description. Finally advising anyone
> >(who is not an actual patent lawyer that could correctly interpret the
> >language and scope of a patent) to go search out patents seems pretty
> >bad advice. That can only result in not even attempting to research some
> >potentially new and innovative approach.
> >
> >Researching prior published work in the area is considerably more
> >helpful. Especially when something is complex beyond belief it has
> >probably attracted various researchers over time and there are most
> >likely various different solutions that have been explored previously.
> >Such existing work can form a good basis for further work.
>
> When you get into the recycling issues with storage, the patents come 
> into play. Also, using the file name to reference revisions is already 
> the subject of a patent previously filed (I no longer own the patent, I 
> sold them to Canopy). There is a third one about to be issued.

Congratulations on obtaining those patents, I hope they will be used
wisely. I am however not a patent lawyer and as such in no position to
evaluate their claims.

As a more useful response, the original poster may want to look at some
of the prior work in this area, I just picked a couple,

  (Cedar File System from Xerox PARC)
    A Caching File System for a Programmer's Workstation (1985)
    Michael D. Schroeder, David K. Gifford, Roger M. Needham

  (Vax/VMS System Software Handbook)
  (TOPS-20 User's Manual)

  (Plan 9 (file system))
    Plan 9 from Bell Labs (1990)
    Rob Pike, Dave Presotto, Sean Dorward, Bob Flandrena, Ken Thompson,
    Howard Trickey, Phil Winterbottom

  (Elephant File System)
    Elephant: The File System that Never Forgets (1999)
    Douglas J. Santry, Michael J. Feeley, Norman C. Hutchinson
    Workshop on Hot Topics in Operating Systems

    Deciding when to forget in the Elephant file system (1999)
    Douglas S. Santry, Michael J. Feeley, Norman C. Hutchinson,
    Alistair C. Veitch, Ross W. Carton, Jacob Otir

  (Ext3Cow)
    Ext3cow: The Design, Implementation, and Analysis of Metadata for a
    Time-Shifting File System (2003)
    Zachary N. J. Peterson, Randal C. Burns

Sites like portal.acm.org and citeseer.ist.psu.edu are good places to
find copies of these papers. They also provide links to other work that
either is cited by, or cites these papers which is a convenient way to
find other papers in this area.

Researching, designing and implementing such systems is a lot of fun,
admittedly often more fun than long term debugging and/or maintaining,
but that is life. Don't get too upset if the end result cannot be
included in the main kernel. Just start over from scratch, you may just
end up with an even better design the second time around.

Jan

