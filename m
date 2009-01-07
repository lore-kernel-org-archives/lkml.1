Return-Path: <linux-kernel-owner+w=401wt.eu-S1762433AbZAGWs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762433AbZAGWs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZAGWsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:48:12 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:36297 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752187AbZAGWsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:48:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NYiSdecbjIAhBgMWDxwWeeK2bljG+fmM0FmDaTNLnuXPnfhMCxSpzU/icp5cmCNQv10xfnVBrJTKwQjcVtmv0Ywlqs5WNj9NlC6X5wDKbReS7TczmFJ6b4TtAH7Eq+07KtUfNjcRQBCDUJeZS2N1YnnSHMMVVhpEAj1n4s8TbMk=  ;
X-YMail-OSG: YVtAnlMVM1m.gzsiQgfMpKXDFyCcmMkhZYqqekrdvAIVNSkeWLv2cTsV0d.K86CD.U9zVFRgmlVC_HKs68Y2_yrCmmJQhGkBOOHfiJ70fTEkd44Ca1VybO0HSa7lgTYRzRUMl8B3RbJxrxZC6tU43GZFLK8BQEhmGMpjn9Xs3PQsgEqN75syO8MwExe.
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <gregkh@suse.de>
Subject: Re: [GIT PATCH] USB patches for 2.6-git
Date: Wed, 7 Jan 2009 14:48:06 -0800
User-Agent: KMail/1.9.10
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, khilman@deeprootsystems.com
References: <20090107192438.GA18146@kroah.com> <49650F2C.9030809@ru.mvista.com> <20090107212801.GA21012@suse.de>
In-Reply-To: <20090107212801.GA21012@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901071448.06565.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2009, Greg KH wrote:
> >   I am dissatisfied how MUSB patches have been handled in general -- this 
> > is not the first breakage, and the valid patches have been lost, so DaVinci 
> > MUSB code keeps being broken since early 2.6.27-rc's (!) up to this time...
> 
> I agree, there's a big disconnect somewhere, I'm sorry about that.  I
> now see David's request to change this patch in my archives :(

There's also that OTG patch to merge ...

After I see this in mainline, I'll send any build fixes needed.

If musb-on-DaVinci can't make 2.6.27, it should be able to finally
make it in 2.6.29 ... :(

What would really suck is if the OMAP3 support manages to work
in mainline but DaVinci is still broken.  At the time the driver
was submitted (for 2.6.27), DaVinci was the only platform to
have a set of "everything works" patches submitted ...

- Dave

