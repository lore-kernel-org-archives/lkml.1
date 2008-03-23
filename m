Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbYCWRry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbYCWRry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 13:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYCWRrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 13:47:46 -0400
Received: from n61.bullet.mail.sp1.yahoo.com ([98.136.44.37]:22486 "HELO
	n61.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754578AbYCWRrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 13:47:45 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 680077.53202.bm@omp400.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=kuLz0GSuv8I5JFwtBepIlHmfLBJkuetZh7TBi9dti4/+5jhA9rShSlhlp/O1RlSbmULRN6Y8KfcsGKNROwKOcKquKIC/AFzoDpyWFfbBsq7P3YEjpOzbYkVTNP46eQpInyKW+WJ8HLZDt2SStzQTqCVSCVp4P+LBA1Ya3x5ZCrM=;
X-YMail-OSG: KN335nQVM1nL.oofeXwgrXzGJRNCbI5HR_3Tgv8Z2tkg9GkI_N3CgmYiqwGvcchfyvistkpsdX.YuWU7pPp0mntkzZ_89x3vBcJB
Date: Sun, 23 Mar 2008 10:47:44 -0700 (PDT)
From: "John T." <j.thomast@yahoo.com>
Subject: Re: UTF-8 and Alt key in the console
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
In-Reply-To: <47E68B50.7060503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <578664.95535.qm@web45709.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "H. Peter Anvin" <hpa@zytor.com> wrote:

> John T. wrote:
> > 
> > That's because you are working in "meta sends ESC" mode.
> > Although this is OK for most applications, for some it isn't.
> > Thus there have always been two modes, "meta sends ESC"
> > and "meta sets 8th bit". (toggled with setmetamode on the
> > console)
> > 
> > Vim relies on "meta sets 8th bit". Unfortunatelly the code
> > for this options does not work in UTF-8 in the console. What
> > I'd like to do is make this a viable option in UTF-8.
> > 
> 
> No, fix vim instead.
> 
> "Meta sets 8th bit" is so obviously and totally broken, since it maps 
> onto real characters, and has been doing so for at least 20 years. 
> Meta-L maps onto LATIN CAPITAL LETTER I WITH GRAVE, both in 8-bit mode 
> and in your proposed UTF-8 mode.  It just becomes even more obvious how 
> unbelievably broken it is when you try to map it onto UTF-8.
> 
> Seriously, fix the crap.
> 
> 	-hpa
> 

OK, let's see if I can answer this.

Vi has 32 years of ESC key use tradition which doesn't play
well with "meta sends ESC".

Even though "meta sets 8th bit" is "broken" in your point-of-view,
that didn't stop it from being used all these years. The fact
that it maps into real characters is not a problem if you can just
use a CTRL-V equivalent in bash or vim.

Furthermore, it is an _option_. No one is obliged to use it.
So it's a question of:

.. _forcing_ the end of "meta sets 8th bit"
.. leaving things the way they are, and have them keep working,
 as xterm did.

So guess we should fix xterm too?

I think you're exagerating.


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ

