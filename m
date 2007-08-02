Return-Path: <linux-kernel-owner+w=401wt.eu-S1760519AbXHBVZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760519AbXHBVZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbXHBVZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:25:45 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39478 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbXHBVZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:25:45 -0400
Date: Thu, 2 Aug 2007 23:27:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Nico Erfurth <masta@perlgolf.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 2.6.22] Adding drivers/usb/misc/iowarrior.c to the Makefile
Message-ID: <20070802212701.GA4326@uranus.ravnborg.org>
References: <46B23DB0.5010702@perlgolf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B23DB0.5010702@perlgolf.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 10:25:20PM +0200, Nico Erfurth wrote:
> This patch adds the new iowarrior module to the Makefile in drivers/usb.
> Currently the module isn't build unless another driver from usb/misc is
> selected.

Can we please just always vist misc like this:
obj-y := misc/

Then we do not need to repeat this stuff in both
drivers/usb/Makefile and drivers/usb/misc/Makefile

Thanks,
	Sam
