Return-Path: <linux-kernel-owner+w=401wt.eu-S1751469AbZH0LO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbZH0LO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbZH0LO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:14:58 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:13543 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbZH0LO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:14:57 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABsHlkpR92Cn/2dsb2JhbADYDgmEEAU
Date: Thu, 27 Aug 2009 13:14:58 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linuxppc-dev@ozlabs.org, Kumar Gala <galak@kernel.crashing.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix book E watchdog to take WDIOC_SETTIMEOUT arg in
	seconds
Message-ID: <20090827111458.GB29382@infomag.iguana.be>
References: <4A8303C6.7070705@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8303C6.7070705@nortel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

> The WDIOC_SETTIMEOUT argument is supposed to be a "seconds" value.
> However, the book E wdt currently treats it as a "period" which is
> interpreted in a board-specific way.
> 
> This patch allows the user to pass in a "seconds" value and the driver
> will set the smallest timeout that is at least as large as specified
> by the user.  It's been tested on e500 hardware and works as
> expected.
> 
> The patch only modifies the CONFIG_FSL_BOOKE case, the CONFIG_4xx case
> is left unmodified as I don't have any hardware to test it on.
> 
> Signed-off-by: Chris Friesen <cfriesen@nortel.com>

Added with some small changes to keep checkpatch happy. (removed trailing spaces + changed sizeof(struct watchdog_info) to sizeof(ident) and changed some spaces in tabs).

Now we only need someone that can look at the CONFIG_4xx cases still :-)

Kind regards,
Wim.

