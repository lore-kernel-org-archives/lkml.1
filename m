Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbXDQL01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbXDQL01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 07:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXDQL00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 07:26:26 -0400
Received: from khc.piap.pl ([195.187.100.11]:33087 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbXDQL00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 07:26:26 -0400
To: Mikko Tiihonen <mikko.tiihonen@iki.fi>
Cc: clemens@ladisch.de, bob.picco@hp.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] hpet: Enable hidden HPET on NVidia motherboards
References: <1176708094.22969.7.camel@dual.local>
	<m3y7kssg98.fsf@maximus.localdomain>
	<Pine.OSF.4.64.0704161624010.487506@kosh.hut.fi>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 17 Apr 2007 13:26:24 +0200
In-Reply-To: <Pine.OSF.4.64.0704161624010.487506@kosh.hut.fi> (Mikko Tiihonen's message of "Mon, 16 Apr 2007 16:33:13 +0300 (EEST)")
Message-ID: <m3abx744yn.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikko Tiihonen <mikko.tiihonen@iki.fi> writes:

> Currently the all the code is protected by CONFIG_HPET.
> Are you proposing to use for example CONFIG_HPET_NVIDIA instead?

Something like that. CONFIG_HPET_NFORCE_DETECT maybe?

> I think that the code should be safe even without it's own config option.

Well, who knows. The hardware side (config bits) are probably safe
and easy to verify, but depending on BIOS assigning address to inactive
device seems risky.
-- 
Krzysztof Halasa
