Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYIXXTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYIXXTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYIXXTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:19:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbYIXXTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:19:22 -0400
Date: Wed, 24 Sep 2008 16:18:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       tglx@tglx.de, mingo@elte.hu
Subject: Re: Warning/Oops report of the week of September 16th, 2008
In-Reply-To: <200809250112.40661.elendil@planet.nl>
Message-ID: <alpine.LFD.1.10.0809241616080.3265@nehalem.linux-foundation.org>
References: <20080916092206.6342c498@infradead.org> <200809250036.47277.elendil@planet.nl> <alpine.LFD.1.10.0809241541320.3265@nehalem.linux-foundation.org> <200809250112.40661.elendil@planet.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Sep 2008, Frans Pop wrote:
> 
> If no other solution is found soon, would a patch to just skip the sysctl 
> table check for this particular case be acceptable?

Well, it would be even _more_ acceptable to have a new Kconfig option that 
just disables the insane parport registrations.

Them you could turn off the /proc files, and if it turns out you don't 
have anything that uses it, you can avoid the warning by actually having a 
smaller kernel with less crap, rather than adding more crap to hide the 
crap. Wouldn't that be nicer?

It would have to be a Kconfig option since we don't _know_ that it's not 
used by anything..

		Linus
