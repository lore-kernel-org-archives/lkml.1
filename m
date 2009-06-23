Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbZFWXZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbZFWXZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbZFWXZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:25:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51939 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752544AbZFWXZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:25:36 -0400
Date: Wed, 24 Jun 2009 00:25:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Richard A. Smith" <richard@laptop.org>
Cc: Andres Salomon <dilinger@collabora.co.uk>, cbou@mail.ru,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: Re: [PATCH 3/5] power_supply: add a TRICKLE_CHARGING status, and
	add it to the olpc driver
Message-ID: <20090623232537.GE16188@opensource.wolfsonmicro.com>
References: <20090622234607.11f61bec@mycelium.queued.net> <20090623103717.GH5422@sirena.org.uk> <4A412CC0.6050500@laptop.org> <20090623224434.GB16188@opensource.wolfsonmicro.com> <4A41618D.4020900@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A41618D.4020900@laptop.org>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 07:13:17PM -0400, Richard A. Smith wrote:
> Mark Brown wrote:

>> A separate file with the detailed information would sidestep this since
>> it's a new interface.  I'm not strongly opposed to adding the new states
>> but I do think it's worth considering other ways of doing this.

> I've got no problems with a new interface.  But, i'm also not the person  
> writing the driver. :)

It's really no bother from the driver point of view either way, it's the
user space applications that are the concern here - are they going to
cope well with a new state appearing there?

> Suggestions on what it would look like?

Probably another sysfs file in the same directory, I'd imagine.
