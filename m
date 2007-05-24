Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbXEXA2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbXEXA2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331AbXEXA2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:28:36 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33811 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756160AbXEXA2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:28:34 -0400
X-Sasl-enc: d8pjaEIpA/ORWFgH53j8lbavRELtF3/1KV3GcFB0zq6l 1179966513
Date: Wed, 23 May 2007 21:28:26 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: 2.6.21-mm2: ACPI exception on resume
Message-ID: <20070524002826.GA2644@khazad-dum.debian.net>
References: <20070520035259.GA13224@khazad-dum.debian.net> <20070521222339.GF11115@waste.org> <20070521230349.GA645@khazad-dum.debian.net> <20070522224515.GW11115@waste.org> <20070523001943.GA3743@khazad-dum.debian.net> <20070523014825.GX11115@waste.org> <20070523041958.GA15952@khazad-dum.debian.net> <2c0942db0705222141se133553re06370476d436b12@mail.gmail.com> <20070523125100.GA826@khazad-dum.debian.net> <2c0942db0705231550x70432ceaw1d428d7a25ffe8aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0705231550x70432ceaw1d428d7a25ffe8aa@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Ray Lee wrote:
> The problem is when the maintainers/submitters get the wrong
> impression, that 2.6.x.y is there to clean up the mess they made. The

Now, that I agree with completely.

> Which is the crux of my problem with your statement. I feel we
> shouldn't give the wrong idea to those authors. They need to know that
> the expectation is that 2.6.x is a stable series, and 2.6.x.y is for
> dealing with unavoidable mistakes.

Well, the only case where I feel a regression is justified is one where it
is caused by a bug in the firmware or the hardware.

At which point my personal opinion is that users of firmware/hardware *that
have a fix available* are to be told to apply the fix, unless the problem is
so serious that it could potentially cause extreme damage (loss of human
life, permanent hardware damage, major data loss).

If there is no fix the user can apply, then it really depends on how
damaging it is to work around the issue for others: you don't punish those
who have non-broken stuff to avoid problems for those that have broken
stuff.

Fortunately, most of the time one can come up with a fix that causes little
to no loss to those with non-broken hardware/firmware.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
