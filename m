Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZFGTU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZFGTU7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 15:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZFGTUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 15:20:48 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:63737 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZFGTUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 15:20:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=rLG5ARDUB3WSnrkYPNe8TWCYHBHFXEbQLh0qrOwroBMLPqEidMqHwxmQvirvUBh5OD
         8Im4igKAWyXo/nWozd59fXRoXIOeCeqD6OnHgsv9C72Cow7ziWbLbruOsv37aHG8AEIm
         GuJqzMJo893NdMTuGKoMl4xLqkQp5UuLViUZA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [git pull] IDE fixes
Date: Sun, 7 Jun 2009 21:23:05 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906071444.33047.bzolnier@gmail.com> <200906071947.19723.bzolnier@gmail.com> <1244401729.8262.102.camel@mulgrave.site>
In-Reply-To: <1244401729.8262.102.camel@mulgrave.site>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906072123.05999.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009 21:08:49 James Bottomley wrote:
> On Sun, 2009-06-07 at 19:47 +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 07 June 2009 18:08:09 James Bottomley wrote:
> > > So I have two specific problems with the way you're trying to one up
> > > libata:
> > > 
> > >      1. You're trying to get a jump on them by adding features as bug
> > >         fixes ... this is incredibly bad release practice.
> > 
> > It is a bugfix.  Long overdue one.
> 
> > However you have to look beyond kernel to see it.  From the commit log:
> > 
> > "
> > From the perspective of most users of recent systems, disabling Host
> > Protected Area (HPA) can break vendor RAID formats, GPT partitions and
> > risks corrupting firmware or overwriting vendor system recovery tools.
> > 
> > Unfortunately the original (kernels < 2.6.30) behavior (unconditionally
> > disabling HPA and using full disk capacity) was introduced at the time
> > when the main use of HPA was to make the drive look small enough for the
> > BIOS to allow the system to boot with large capacity drives.
> > 
> > Thus to allow the maximum compatibility with the existing setups (using
> > HPA and partitioned with HPA disabled) we automically disable HPA if
> > any partitions overlapping HPA are detected.  Additionally HPA can also
> > be disabled using the "nohpa" module parameter (i.e. "ide_core.nohpa=0.0"
> > to disable HPA on /dev/hda).
> > "
> > 
> > Yes, it is true that there is no rush.
> 
> So why 2.6.30-rc7 then?
> 
> > OTOH there are absolutely no valid technical reasons to slow it down!
> 
> There is incredibly valid reason not to put this in 2.6.30-rc7: You've
> added a feature (HPA) which ide previously ignored, so now you need to

No.  HPA as feature was always supported back to 2.4.x days.

End of discussion.  I'm not even reading the rest of your mail.

Please go read the code and don't come back till you do.
