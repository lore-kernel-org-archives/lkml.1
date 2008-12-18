Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752512AbYLRKIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbYLRKIj (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbYLRKI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:08:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54889 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbYLRKI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:08:28 -0500
Date: Thu, 18 Dec 2008 10:07:47 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Sam Ravnborg <sam@ravnborg.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Jan Beulich <jbeulich@novell.com>, linux-arch@vger.kernel.org,
        Alexander van Heukelum <heukelum@mailshack.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/many] PROC macro to annotate functions in assembly files
Message-ID: <20081218100747.GA10593@flint.arm.linux.org.uk>
Mail-Followup-To: Alexander van Heukelum <heukelum@fastmail.fm>,
	Sam Ravnborg <sam@ravnborg.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Jan Beulich <jbeulich@novell.com>, linux-arch@vger.kernel.org,
	Alexander van Heukelum <heukelum@mailshack.com>,
	Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm> <1229505475-10219-2-git-send-email-heukelum@fastmail.fm> <20081217172640.GB5436@uranus.ravnborg.org> <20081217173824.GF8078@localhost> <20081217180023.GA5783@uranus.ravnborg.org> <1229593918.31758.1290707307@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229593918.31758.1290707307@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 10:51:58AM +0100, Alexander van Heukelum wrote:
> Agreed. I vote to complement the existing ENDPROC annotation with
> the proposed PROC annotation. Let's call that an extension, not
> something new ;). As it stands it is not impossible to go with
> ENTRY/ENDPROC for code and ENTRY/END for data. However, ENTRY
> implies alignment and the prefered alignment for code and data
> might differ.

Have you looked at the number of ENTRY uses for code vs for data?
If all you're after is separating the two uses, then it might be a
smaller patch to change the ENTRY use for data rather than changing
all the ENTRY uses for code.

There are 589 uses of ENTRY in arch/arm/*/*.S.  Of those about 50
aren't called code.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
