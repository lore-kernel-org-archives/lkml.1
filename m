Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbYIZSx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbYIZSx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYIZSxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:53:46 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:35442 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbYIZSxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:53:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=Y3UZMv705gd6Do2TES1cHBAvScxPOH5gjBinPiNaUNCX+N2xl7qBFyUVNcFFqy9Yjd
         x4Mt7Mg9o4ibBOTl+EXBtFhWGDtrjEyIj8HvZK4v1wI6JPn2uenv5GKKj+n9zu3+t1UN
         nScrjHqDKL96S+jUMfcylMt0U2k+LtkFz7AlQ=
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] Bug in rt2x00 rt73usb driver in latest git kernel
Date: Fri, 26 Sep 2008 20:53:39 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Iwo Mergler <iwo@call-direct.com.au>,
       Paul Eddington <eddingtonpaul@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <762793250809241102n61ea8f00kca8138bc3c8df2e6@mail.gmail.com> <200809261452.28482.rjw@sisk.pl> <200809262024.57874.IvDoorn@gmail.com>
In-Reply-To: <200809262024.57874.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809262053.39930.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2008, Ivo van Doorn wrote:
> On Friday 26 September 2008, Rafael J. Wysocki wrote:
> > On Friday, 26 of September 2008, Iwo Mergler wrote:
> > > Paul Eddington wrote:
> > > > Hi,
> > > > 
> > > > While running the latest git kernel (linus' tree) and using a usb wifi
> > > > card, I got this error in dmesg:;
> > > > 
> > > > phy2 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry
> > > > in the non-full queue 2.
> > > > Please file bug report to http://rt2x00.serialmonkey.com.
> > > > 
> > > > This is not reproducible easily, but it has occurred on two occasions
> > > > both while connected to a WEP encrypted AP with a 40-bit key and
> > > > performing many file samba transfers at full speed 54mbits.
> > > > 
> > > > I tried to report the bug there but was unable to register and edit
> > > > the bug reports wiki page.
> > > > If there is any more information or help required to debug this,
> > > > please let me know.
> > > > 
> > > > Regards,
> > > > Paul
> > > > --
> > > 
> > > Hi Paul,
> > > 
> > > the rt2x00 drivers are currently a very fast moving target. You may want
> > > to experiment with the rt2x00 kernel tree instead - it gets the patches
> > > (and the bugs) earlier. ;-)
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=summary
> > > 
> > > I added the rt2x00 mailing list to CC.
> > 
> > Well, according to the information I've received from Paul this particular
> > problem is a regression from 2.6.26, so it's been added to the list of recent
> > regressions.
> 
> Seriously, this error message is the most annoying rt2x00 error message _ever_.
> It should have been fixed 3 kernels ago, but it keeps popping up again and again.
> 
> Paul, what is the git commit id with which you encountered this bug?

Oh and please test rt2x00.git as well, since some patches which should fix this issue
are in there (and in wireless-testing.git) but not in Linus' tree since they are scheduled
for 2.6.28.

Ivo
