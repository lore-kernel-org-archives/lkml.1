Return-Path: <linux-kernel-owner+w=401wt.eu-S1762435AbYGOSiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762435AbYGOSiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbYGOSiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:38:08 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:40045 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbYGOSiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:38:06 -0400
Message-ID: <487CEE55.2010904@nortel.com>
Date: Tue, 15 Jul 2008 12:37:09 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Garzik <jeff@garzik.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Frans Pop <elendil@planet.nl>, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <200807151757.10626.elendil@planet.nl> <20080715180535.GA6080@khazad-dum.debian.net> <487CE917.3000000@garzik.org> <alpine.LFD.1.10.0807151122010.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151122010.3017@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2008 18:37:14.0910 (UTC) FILETIME=[CD5943E0:01C8E6A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> Why compile them into the module, when that's just the _inflexible_ model?
> 
> Why not just install them with the module (perhaps in the module 
> directory, perhaps not), and just load them? 
> 
> Really. You _do_ have do to "make modules_install" or similar. That has 
> _already_ got inter-file dependencies (ie some modules simply depend on 
> other modules). I'm not seeing why you cannot accept change.

Even if the end goal is to support more flexible firmware loading, it 
would seem to make sense to allow building the firmware into the 
module--if only as an interim step to avoid breaking existing setups.

Chris
