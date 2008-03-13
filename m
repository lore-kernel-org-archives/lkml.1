Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbYCMFK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbYCMFK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 01:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbYCMFKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 01:10:12 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:42518 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750722AbYCMFKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 01:10:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TpkLDgP878Y6k4E9EbR7Vkev2sFA/V++nyleyP3G+GO546BUH8FXOMBRyAF7yOOU8OmfqSeaKgLjkSqeln6edrilq4075MCvJmEDgRWzEg4Lme2kBh99vRobqPqLuGVjZgEoHQQ9gnQkT03A8UlkQkNHFfBKyfK/dB1HPusDZxY=  ;
X-YMail-OSG: i8a6LZ0VM1kXFTrxMxM56L.1p3pUGeaerSGEDU8XBvdVk3j_cfK91jzOvIr0HN9D2DHXKwNgkg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: ian <spyro@f2s.com>
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
Date: Wed, 12 Mar 2008 20:39:48 -0800
User-Agent: KMail/1.9.6
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main> <200803121452.47600.david-b@pacbell.net> <1205364361.24230.4.camel@wirenth>
In-Reply-To: <1205364361.24230.4.camel@wirenth>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803122139.48911.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008, ian wrote:
> > 
> > To me, they aren't regulators at all.  :)
> 
> I dunno.
> 
> Regulate - to control.
> 
> A switch certainly controls voltage. 

You could stretch the terminology that way, yes.


> Admittedly the granularity is a 
> little coarser than a nice digitally controlled regulator, but it fits
> the model...

Yet if you go into a parts catalog, you'll see that regulators
and switches (low side, high side, etc) are different parts.
Also, that many (most?) regulators aren't switchable.

Given my druthers, there'd be no repurposing of common terms
like "switch" and "regulator".  That's all I'm getting at; in
normal usage, they are two different things.  (And what we
care about is their output -- a power domain, possibly shared,
possibly somewhat controllable -- not how it works.)

- Dave

