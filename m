Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZG2NIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZG2NIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbZG2NIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:08:42 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:44264 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbZG2NIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:08:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BpjCa7CNdVVG3jBCMCpXcU5rayrjqZd1QgTzUiVusObVncVIru0J6Aia7o/vHQjgia
         smaF6D1TvqQi4xdNp45+oPw/+Uu6j2S/ZQ0IuPE2DI8FtHBRZdC9nqmlVwf2ChSvq5uB
         dqHsTQ/+d91PyD1FAGldk9p24a59FnKLn7mCk=
MIME-Version: 1.0
In-Reply-To: <4A704777.70001@mnementh.co.uk>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
	 <4A6F033B.7030302@mnementh.co.uk>
	 <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>
	 <20090729115817.GA12223@rakim.wolfsonmicro.main>
	 <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>
	 <20090729124233.GA12802@rakim.wolfsonmicro.main>
	 <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com>
	 <4A704777.70001@mnementh.co.uk>
Date: Wed, 29 Jul 2009 22:08:41 +0900
Message-ID: <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com>
Subject: Re: MMC: Make the configuration memory resource optional
From: Magnus Damm <magnus.damm@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 9:58 PM, Ian Molton<ian@mnementh.co.uk> wrote:
> Magnus Damm wrote:
>
>>> Indeed.  It's actually much worse than you say, each individual ARM
>>> architecture has its own clock API implementation of varying quality and
>>> of course there are architectures that don't do the clock API at all.
>>
>> Yeah. This is exactly why I don't want to block on the clocklib
>> implementation.
>
> Yeah, good idea... lets ignore the problem until its so big we cant fix it
> at all...

Note that I don't need clocklib to get the tmio_mmc driver working for
my platform. It's something _you_ need for the MFD chips. But you seem
to want me to fix it for you even though I don't have any particular
need for it.

/ magnus
