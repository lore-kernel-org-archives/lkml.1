Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbYIXXMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbYIXXMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYIXXMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:12:44 -0400
Received: from cpsmtpo-eml01.kpnxchange.com ([213.75.38.150]:35596 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748AbYIXXMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:12:43 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Warning/Oops report of the week of September 16th, 2008
Date: Thu, 25 Sep 2008 01:12:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       tglx@tglx.de, mingo@elte.hu
References: <20080916092206.6342c498@infradead.org> <200809250036.47277.elendil@planet.nl> <alpine.LFD.1.10.0809241541320.3265@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809241541320.3265@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809250112.40661.elendil@planet.nl>
X-OriginalArrivalTime: 24 Sep 2008 23:12:41.0366 (UTC) FILETIME=[0B369360:01C91E9B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2008, Linus Torvalds wrote:
> In the meantime, that warning is just best ignored entirely. It's not a
> kernel bug per se, or even anything that is fixable without changing
> exported user interfaces that in my opinion aren't necessarily even
> _worth_ changing (the only reasonable change is extending on the insane
> interface that nobody cares about).

Yep, I agree it's basically harmless and I have been ignoring it. But that 
does not make it less annoying as, because of the call trace, it will 
continue to show up in logcheck mails every time.

If no other solution is found soon, would a patch to just skip the sysctl 
table check for this particular case be acceptable?
