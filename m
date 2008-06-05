Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbYFEPn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbYFEPn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbYFEPnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:43:18 -0400
Received: from gw.goop.org ([64.81.55.164]:35819 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbYFEPnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:43:18 -0400
Message-ID: <4848096D.9010603@goop.org>
Date: Thu, 05 Jun 2008 16:42:37 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Stable Kernel <stable@kernel.org>,
       x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: set PAE PHYSICAL_MASK_SHIFT to match 64-bit
References: <4848046A.5060006@goop.org> <484823BD.76E4.0078.0@novell.com>
In-Reply-To: <484823BD.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Hmm? There's 11 bits available - why would anyone want to assign bits
> from the sufficiently official (at least as far as AMD is concerned, I'm not
> sure I saw a precise statement on Intel's side) frame number bits?

The Intel docs list those 11 bits as available to software, and are not 
reserved for any future flags they may want to add.  I was a bit 
surprised too.

>  And
> even if they would, it would certainly take some control register bit to
> enable the feature, so shrinking the mask if that would ever happen
> would seem more appropriate.
>   

I suppose.

> Bottom line - I'd suggest pushing both 32- and 64-bits up to 52.
>   

We could have an auction:

    Do I hear 46? 47? 48?  50?  52!  Going once, twice, 52 bits!

Anyway, we can fix it later in a separate patch.  This is a 
change-as-little-as-possible bugfix patch.

    J
