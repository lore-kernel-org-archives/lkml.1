Return-Path: <linux-kernel-owner+w=401wt.eu-S935057AbXG2TjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935057AbXG2TjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 15:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763965AbXG2TjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 15:39:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:10445 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773AbXG2TjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 15:39:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=QDYY50PB3AQ29CWHM5enQfEYkpPtgFi0+fwPTCQMOXMaXH7zZmuwqKLdakQwbHQZjPk1r3IibEs1OPc3kFV9xMExUgb+tYrVBxW+KQk+rd3jzx4V0sOmYAdtjxUOqcKp76ValsDRwuxJtqNTqu65YZJmliNI0hWKjFg0bomC4jc=
Message-ID: <46ACEBD3.8000200@googlemail.com>
Date: Sun, 29 Jul 2007 21:34:43 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [BUG] undefined reference to `kobject_actions'
References: <20070729193401.GA18225@flint.arm.linux.org.uk>
In-Reply-To: <20070729193401.GA18225@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> Many ARM platforms fail to build with the following:
> 
> drivers/built-in.o: In function `store_uevent':
> hid-input.c:(.text+0x19c4c): undefined reference to `kobject_actions'
> 
> It appears that if hotplug is disabled, kobject_actions is ifdef'd
> away but hid-input still references it.
> 

Is already fixed in -mm , try patch from :

http://lkml.org/lkml/2007/7/29/206

Regards,

Gabriel

