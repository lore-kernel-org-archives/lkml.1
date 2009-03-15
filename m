Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbZCOVR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbZCOVR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 17:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZCOVRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 17:17:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60642 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZCOVRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 17:17:48 -0400
Date: Sun, 15 Mar 2009 22:17:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Valdis.Kletnieks@vt.edu, porte64@free.fr, linux-kernel@vger.kernel.org
Subject: Re: read-only partitions: does the policy apply to all metadata ?
Message-ID: <20090315211043.GA1395@ucw.cz>
References: <355270241.1702481236702404399.JavaMail.root@spooler8-g27.priv.proxad.net> <29610.1236705759@turing-police.cc.vt.edu> <20090310173437.2a8114b2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310173437.2a8114b2@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-03-10 17:34:37, Alan Cox wrote:
> On Tue, 10 Mar 2009 13:22:39 -0400
> Valdis.Kletnieks@vt.edu wrote:
> 
> > On Tue, 10 Mar 2009 17:26:44 BST, porte64@free.fr said:
> > > When a partition is mounted as read-only, does the kernel
> > > really prevent ANY byte to be written to it, including
> > > any metadata ?
> > 
> > It's very hard to come up with a workable way to do a true read-only
> > mount of a journaled filesystem such as ext3 - what do you do if there's
> > anything in the journal that needs to be replayed?
> 
> Replay it to a snapshot backed by the r/o fs ...

Or you can use 'ro, noload' to just ignore the journal. See the docs.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
