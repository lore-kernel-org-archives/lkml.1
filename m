Return-Path: <linux-kernel-owner+w=401wt.eu-S936675AbXG2Vpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936675AbXG2Vpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936050AbXG2VpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:45:13 -0400
Received: from web52001.mail.re2.yahoo.com ([206.190.49.248]:36125 "HELO
	web52001.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S937409AbXG2VpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:45:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=bOIeunShKFnMA+fBdtbC+kTPCwmfzNodTmxwrzxb69/EFgpIjOtlHwXDQdJU4mKIyReNjmbNUfCZJRmEtHKheW3jhXPvr95tF3aYHro1auaKmN3Ck6Lx85rNEVChUZ9Z1G6Ix50Dxq8fHl/tSH8c1D0m6V1mMhdRNacNGHagzkY=;
X-YMail-OSG: doDkHckVM1kkoO20i5aBV_yeTs.9EAkvfdC03XBIKP484y5LP1nhgqH00zAyuZ.fizgCMQzb19V4mx5eDGaDX6sdFDyymmJ2h5KdkRSym31iNHxQhSORStLN70EfnQ--
Date: Sun, 29 Jul 2007 14:45:09 -0700 (PDT)
From: "Hendrik ." <chasake@yahoo.com>
Subject: Re: Reading a bad sector does not report failure as 'read error' but hangs PC with 'Machine Check Exception'
To: linux-kernel@vger.kernel.org
In-Reply-To: <20070729213051.20ebc51e@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <4677.91718.qm@web52001.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> hangs. If I try it after a reboot with 'mcelog --k8
>> --ascii' or whatever parameter, there is no output
at
> You could type error back in from the email ?

Ok I copied it into the tool, it gives me:

CPU 0 4 northbridge TSC b7d4a144d0 
  Northbridge ECC error
  ECC syndrome = 0
STATUS 0 MCGSTATUS 4

This is a bit strange because I repeatedly tested the
RAM yesterday and it gives no problems. And even more
interesting: the error occurs at a reproducible
moment: when reading the bad sector from the Seagate
harddisk. And with an older kernel I was able to just
copy all stuff from the drive using dd_rescue... I do
not have ECC RAM in my PC by the way.

> > Isn't it strange to say that the controller does
> > something bad if there is just a bad sector on the
> > drive that is reported and handled correctly in an
> > older kernel 
> Not really. Its very strange it gives an MCE at all
> but this is a known
> failure path (and should be a fixed known failure
> path) for the Nvidia SATA.

So how to proceed in tackling this problem now? Is
there anything I can do to (help you guys ;)) fix it?
At this moment it unfortunately does not look to me as
a fixed failure path...


       
____________________________________________________________________________________
Take the Internet to Go: Yahoo!Go puts the Internet in your pocket: mail, news, photos & more. 
http://mobile.yahoo.com/go?refer=1GNXIC
