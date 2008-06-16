Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbYFPONS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbYFPONS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYFPONI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:13:08 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:63051 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYFPONH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:13:07 -0400
Message-ID: <fa686aa40806160713q51f3d132w2fef2a2473faad1@mail.gmail.com>
Date: Mon, 16 Jun 2008 08:13:06 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [PATCH] [RFC v3] OF: OpenFirmware bindings for the mmc_spi driver
Cc: "Anton Vorontsov" <avorontsov@ru.mvista.com>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Jochen Friedrich" <jochen@scram.de>,
       "Segher Boessenkool" <segher@kernel.crashing.org>,
       "Gary Jennejohn" <garyj@denx.de>,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080614175723.209e93dc@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080605161624.GA517@polina.dev.rtsoft.ru>
	 <20080614175723.209e93dc@mjolnir.drzeus.cx>
X-Google-Sender-Auth: 3dc830d500fc4389
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 9:57 AM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Thu, 5 Jun 2008 20:16:24 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
>
>> Here is v3. I'm out of ideas if you won't like it. :-)
>>
>> v3:
>> - Now these bindings are using bus notifiers chain, thus we adhere to the
>>   spi bus.
>>
>
> Now this was nice and clean. I take it Grant doesn't like this version
> though. What's the downside of it?

No, I don't.  I like the v2 approach better as long as it is been
changed to address your comments.  This approach I think is needlessly
complex and non-obvious (relying on the notification chain instead of
being part of the probe call).  It will break in non-obvious ways if
the notifier module is loaded after the mmc_spi driver.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
