Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbYIHLXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbYIHLXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 07:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYIHLXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 07:23:23 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:43798 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752254AbYIHLXX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 07:23:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RTpg0b+ITlYIC0egiBBB8YCyI7lIZnfax4JrgEW2NCglilbFtHctKo1TmmTaXF1I29weoHge484nSMZ6J5McOpHIdqXc0Y1aaicykH0c71kB5NYV8jBjWg013JbKHbOBv8F7mKjUSSTfruB5iUVXtZvWr5eKBVp3SYrnBrA9LGQ=  ;
X-YMail-OSG: zdjbr4EVM1noRqB1vlqrCoTJAeI7sfXeEqnWES5_i7tZFp795DRRFi1ZHLyptgkvdeEUrpNd3eTZnzHEi8od.TV_AXZHyJu8Fo0Nf3UvMMo.EcZIwzjWH8Lw0Tjm7sqM.EM-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH 0 of 3] Low memory corruption detection and workaround
Date: Mon, 8 Sep 2008 21:23:04 +1000
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Hugh Dickens <hugh@veritas.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
References: <patchbomb.1220777491@localhost> <48C3F237.1020503@tuffmail.co.uk>
In-Reply-To: <48C3F237.1020503@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809082123.04780.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008 01:24, Alan Jenkins wrote:
> Jeremy Fitzhardinge wrote:
> > Hi Ingo,
> >
> > This series implements a check and workaround for memory corruption in
> > low memory.
> >
> > The first patch adds the basic mechanism.  The second adds some
> > enchancements from Hugh, namely periodic scanning for badness.  The
> > third tidies the user interface up by adding a proper Kconfig option
> > and several kernel command-line parameters to enable the feature and
> > control the amount of memory it scans and how often.  It also uses a
> > WARN() with the intention of getting any output into ksymoops.org.
> >
> > I've tested it as far as I can, but none of my systems seem to exhibit
> > this type of corruption so I haven't seen the failure case output.  I
> > hope Alan and Rafał can test this version of the patch and report it
> > does the expected thing.
> >
> > [ Hugh - I took the liberty of splitting your patch up into a delta on
> >   top of mine, moving the pure bugfixes into my base patch, and
> >   putting your additional code into the new patch From you with your
> >   sign-off from the original patch, and adding my own sob to reflect
> >   the changes I made.  I hope you don't mind. ]

Why not high memory as well? We put page tables there too...

(rant: why can we still buy non-ECC memory?)
