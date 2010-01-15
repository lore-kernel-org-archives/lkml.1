Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab0AORzD (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 12:55:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797Ab0AORzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 12:55:01 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:41648 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab0AORzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 12:55:00 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: option driver freezing entire system
Date: Fri, 15 Jan 2010 18:55:46 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: smurf@smurf.noris.de, LKML Mailinglist <linux-kernel@vger.kernel.org>
References: <1263577116.27788.131.camel@localhost>
In-Reply-To: <1263577116.27788.131.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001151855.46217.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 15. Januar 2010 18:38:36 schrieb Kasper Sandberg:
> Hello..
> 
> Im having some issues with some huawei e1752 modems, the computer
> sometimes completely freezes, and i suspect its due to the option
> driver, as it doesnt happen if i dont modeswitch them to appear as
> option modem.
> 
> Do you have any idea what might cause this? i looked all over the system
> logs and theres nothing to help at all, but i have seen this spanning
> from .26 to .32, on multiple computers, and i just dont know what to do
> to fix it.

Please recompile your kernel with lockdep. This should improve
debugging.

	Regards
			Oliver
