Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZDFHOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZDFHOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 03:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZDFHOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 03:14:42 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:37752 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbZDFHOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 03:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Bcl1PmtCiXPCn5jJAgacNRHp3rFJ3fE+dpr7rFSJC1N9CT3kBx2/+h8m9S+izDSOiq
         9TsybFuXsidVNObND8DDEICvV3Halj9Qs/zL+KI1GyzP2okg0C1tzwNl0Z3bp2oryv+K
         wfZr5A1P7w4oGJbgV4vPJU0ToiMZWCXySL3sw=
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: ath9k becon loss messages
Date: Mon, 6 Apr 2009 09:14:31 +0200
User-Agent: KMail/1.9.10
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Michael Buesch <mb@bu3sch.de>, Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
References: <1238923439.4120.9.camel@localhost.localdomain> <1238925174.4120.12.camel@localhost.localdomain> <87bprbif2f.fsf@litku.valot.fi>
In-Reply-To: <87bprbif2f.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904060914.32245.helmut.schaa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 5. April 2009 schrieb Kalle Valo:
> Jaswinder Singh Rajput <jaswinder@kernel.org> writes:
> 
> >> And besides that, I think one can easily remotely trigger this
> >> message and flood the logs. So it should probably _also_ be
> >> ratelimited.
> >
> > normally it prints after 120 seconds:
> >
> > [ 1078.848434] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 1198.822913] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 1318.824931] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request

> Then there is something happening in ath9k or your AP which prevents
> ath9k from receiving beacons. Try pinging your AP with 100 ms
> interval. Do you see anything happening in 120 s intervals?

NetworkManager typically scans every 120 seconds and I can also trigger
the messages by a manual scan with iwlist. I did not dig any further but
the messages seem to appear right at the end of the scan. Tried with iwlagn
and both sw_scan and hw_scan.

Helmut
