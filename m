Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbXIBWOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbXIBWOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 18:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbXIBWOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 18:14:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42615 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbXIBWOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 18:14:34 -0400
Date: Mon, 3 Sep 2007 03:57:40 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Alistair John Strachan <alistair@devzero.co.uk>
cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Winischhofer <thomas@winischhofer.net>,
       Greg Kroah-Hartman <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH -mm] sisusbvga: Fix bug and build warnings
In-Reply-To: <alpine.LFD.0.999.0709030305030.29617@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709030348580.31154@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
 <alpine.LFD.0.999.0709030159320.29617@enigma.security.iitk.ac.in>
 <9a8748490709021323k3d4adbddv53346aacdd66ab57@mail.gmail.com>
 <200709022218.06849.alistair@devzero.co.uk>
 <alpine.LFD.0.999.0709030305030.29617@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Sep 2007, Satyam Sharma wrote:
> 
> On Sun, 2 Sep 2007, Alistair John Strachan wrote:
> > 
> > The encoding is set to ISO-2022-JP, this is probably breaking things.
> 
> ??? I have no clue how/why/when that suddenly happened.
> 
> I clearly see "Content-Type: TEXT/PLAIN; charset=us-ascii" for the first
> mail I sent out -- but all the replies seem to have somehow got this
> weirdness.

OK, I've got it figured out now. What happened is this -- alpine has this
nifty feature that (if not explicitly set) it will automatically adjust
the content-type encoding of outgoing mails depending upon the kind of
text it sees written in the mail. Now when I normally post (eg. the first
mail in this set), it naturally goes out as US-ASCII. What was special
about the other mails was that each contained GCC's error/warning output.
And if you've noticed it produces that totally pointless special non-
US-ASCII 'quotes' around wherever it points out the name of an identifier
-- and that confused alpine into thinking I was writing in Japanese (!)
Anyway, I've explicitly set all mails to be sent out as US-ASCII only
now, so hopefully things will be ok ...
