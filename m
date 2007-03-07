Return-Path: <linux-kernel-owner+w=401wt.eu-S965193AbXCGMsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965193AbXCGMsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 07:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965196AbXCGMsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 07:48:21 -0500
Received: from khc.piap.pl ([195.187.100.11]:44224 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965193AbXCGMsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 07:48:20 -0500
To: "Oleksiy Kebkal" <lesha@evologics.de>
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, rmk@arm.linux.org.uk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org, "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
	<m3bqj6jebt.fsf@maximus.localdomain>
	<57354eff0703062113g11ca7d34o6ed82de8195353f1@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 07 Mar 2007 13:48:18 +0100
In-Reply-To: <57354eff0703062113g11ca7d34o6ed82de8195353f1@mail.gmail.com> (Oleksiy Kebkal's message of "Wed, 7 Mar 2007 06:13:10 +0100")
Message-ID: <m3ejo1usml.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Oleksiy Kebkal" <lesha@evologics.de> writes:

> The name of the option is not CCTS, but CRTSCTS, isn't it? So, you may
> not only want to pause own transmission when CTS is inactive, but to
> control the transmission flow from the remote side. Why should RTS be
> active when the port is open even without CRTSCTS?

Because you'd break many devices otherwise.
-- 
Krzysztof Halasa
