Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbYB1DcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbYB1DcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 22:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYB1DcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 22:32:03 -0500
Received: from n36.bullet.mail.ukl.yahoo.com ([87.248.110.169]:22736 "HELO
	n36.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754687AbYB1DcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 22:32:01 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2008 22:32:00 EST
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 70378.84586.bm@omp409.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=plc4oZrenlzsD8XmOwm/tvHb3B4+vWppA8Fagz7gk87zj3wSWRFoInZbRK7cOWEFz0Jn1suW5tWYConN8lbz6W0+q3wO79+5nT7Z63Y4Iqd65cVV6gm3Y62Ug8Od3tVf0u1AXTLiBojvdxCf/+oaSzzPA4x8fkQNI369qvc1ltA=;
X-YMail-OSG: Vx2wJ1YVM1nI9FUEm8M7GZUWUM4OhWmCYBGaT1cGIErimt.WBXgpqBXZi.PNEr3rpW.1CYMfGDVl9k5hljpnlPf2Cw--
Date: Wed, 27 Feb 2008 19:26:05 -0800 (PST)
From: zkopex mtrof <zkopex@yahoo.com>
Subject: Re: [Regression in 2.6.25-rcX] CD/DVD writer no longer works
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1203910587.12670.9.camel@homer.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <916729.18642.qm@web45209.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Mike Galbraith <efault@gmx.de> wrote:
> 
> On Sun, 2008-02-24 at 12:57 -0800, zkopex wrote:
> > Hello,
> 
> Greetings,

Hi again,

> 
> > I am using Debian Sid on a Toshiba A100 laptop. My CD/DVD
> > writer functions very well on 2.6.23.16 and 2.6.24.2.
> > 
> > I tried 2.6.25-rc2-git7, and I was very sad to notice that
> > when I tried to write a CD, wodim started to output the
> > following: "Warning: controller returns zero sized CD
> > capabilities page."
> 
> Yeah, I saw that using k3b.

The effects of the bug are seen when using wodim (or cdrecord)
directly from the command line too.

> 
> > Since I was able to use this CD/DVD writer successfully with
> > previous versions of Linux, I believe that this is a regression
> > in 2.6.25-rcX series.
> > 
> > I am willing to try patches and to do pretty much anything
> > to debug/fix this problem.
> 
> Sounds like you're having the same problem I am.  In my case, reverting
> all but one line of commit 6b00769fe1502b4ad97bb327ef7ac971b208bfb5
> cures it, though I don't see why.
> 
> Revert patch below is against freshly hatched rc3 if you want to try it.
> 
[patch snipped]

Thank you very much! The patch you supplied fixes the regression!

What do we need to do in order to get this patch applied in
mainline so that the regression gets fixed?

To be honest, I was expecting a few replies from the appropriate
kernel developers. It looks like I have missed something in
my regression report.

Nevertheless, thank you again for your attention/kindness.

Regards,

- zkopex




      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping

