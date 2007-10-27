Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbXJ0I6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbXJ0I6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 04:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbXJ0I6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 04:58:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36243 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbXJ0I6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 04:58:08 -0400
Date: Sat, 27 Oct 2007 10:57:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Michael Buesch <mb@bu3sch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [2.6 patch] fix USB_OHCI_HCD_SSB dependencies
Message-ID: <20071027085748.GB3742@elte.hu>
References: <20071027010647.GN30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071027010647.GN30533@stusta.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_00,UPPERCASE_25_50 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
	0.4 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> -	depends on USB_OHCI_HCD && (SSB = y || SSB = CONFIG_USB_OHCI_HCD) && EXPERIMENTAL
> +	depends on USB_OHCI_HCD && (SSB = y || SSB = USB_OHCI_HCD) && EXPERIMENTAL

oops, indeed ... my Kconfig fu needs strengthening. Does Kconfig warn 
somewhere if it sees an erroneous CONFIG_ token?

	Ingo
