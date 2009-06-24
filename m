Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbZFXKJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbZFXKJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbZFXKJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:09:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44685 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbZFXKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:09:11 -0400
Date: Wed, 24 Jun 2009 11:09:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Richard A. Smith" <richard@laptop.org>
Cc: Andres Salomon <dilinger@collabora.co.uk>, cbou@mail.ru,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: Re: [PATCH 3/5] power_supply: add a TRICKLE_CHARGING status, and
	add it to the olpc driver
Message-ID: <20090624100911.GB21919@sirena.org.uk>
References: <20090622234607.11f61bec@mycelium.queued.net> <20090623103717.GH5422@sirena.org.uk> <4A412CC0.6050500@laptop.org> <20090623224434.GB16188@opensource.wolfsonmicro.com> <4A41618D.4020900@laptop.org> <20090623232537.GE16188@opensource.wolfsonmicro.com> <4A416952.2050809@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A416952.2050809@laptop.org>
X-Cookie: Now I am depressed ...
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 07:46:26PM -0400, Richard A. Smith wrote:
> Mark Brown wrote:

>> It's really no bother from the driver point of view either way, it's the
>> user space applications that are the concern here - are they going to
>> cope well with a new state appearing there?

> I can only speak for OLPC's usage.  But my script, the documentation on  
> our wiki, and HAL are the only things that I know of that use that info  
> and none of them should have any problem with it changing.

The other thing that has a reasonable number of users is the in-kernel
APM emulation - when I last looked quite a few users were using that
still.

I'd expect that either HAL or things that use it would need to know
about the new state to do something sensible with it.  All the widely
deployed users should be using those, I don't recall any of the other
things I found being things that I'd particularly heard of.
