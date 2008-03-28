Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbYC1UPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbYC1UPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbYC1UO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:14:57 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:22013 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754558AbYC1UO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:14:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vYZEJlscPKxNaPqD5NhDXytpdYgZkHe/hPLk4jLg7+uDW7B3AiGJKJ99Bb+5U2fw1SdNRnJ7AsjX7Wrs9RoZPSYUnytIeibnoy7sLLeBG7tcNPRVEtO9dfzTZSDmh6Mhuna8Z26pX+Pj5I+DwOWdlMqu1hdyUSiCTPPH5sFrJLc=  ;
X-YMail-OSG: CEP7DzEVM1lg4laDxFoKRNEeavUqGVUpd1jHuYrTN1Rzu3Qfv4mFNc58ErtXedRu8iDhoXCHTw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: 2.6.25-rc7: Ugh.
Date: Fri, 28 Mar 2008 13:14:52 -0700
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Mark Lord <lkml@rtr.ca>,
       David Miller <davem@davemloft.net>, jkosina@suse.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, pavel@suse.cz,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com
References: <20080327160700.GB828@suse.de> <20080328102010.GA633@elte.hu> <alpine.LNX.1.10.0803281557160.27567@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0803281557160.27567@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281314.53653.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008, Jan Engelhardt wrote:
> > 	If we think that an approach is superior (which
> > your new RTC code certainly is), we have to take up the responsibility
> > of pushing that as a prominent, default choice and excluding the old
> > code. That ends up benefiting everyone, reduces complexity of the
> > kernel. You wont see anyone shed tears for the old code.
> 
> Users with audio-related usage patterns do, as SND_RTCTIMER
> still depends on old rtc :-/

-ENOPATCH :)

Last time this specific issue came up, a related point was
that the relevant ALSA documentation in this area needed
updating too.  ISTR it assumed there was only one kind of
RTC, and had a few other issues.

- Dave

