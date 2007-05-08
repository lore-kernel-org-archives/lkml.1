Return-Path: <linux-kernel-owner+w=401wt.eu-S967355AbXEHLkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967355AbXEHLkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967311AbXEHLkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:40:05 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:49941 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967171AbXEHLkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:40:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=g+iIsR45RW46WzdIck/14rdUsGFugKjzOURXKadgoGP9iAhv0C0iAbwqMaQqF
	F3tn0ceZjLEvNVjS2VsHdPP9g==
Date: Tue, 8 May 2007 13:40:01 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jeff Garzik <jeff@garzik.org>, Russell King <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 3/3] Intel IXP4xx network drivers
Message-ID: <20070508114001.GC32055@xi.wantstofly.org>
References: <m3abwhcy74.fsf@maximus.localdomain> <m3vef5biob.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3vef5biob.fsf@maximus.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 02:07:16AM +0200, Krzysztof Halasa wrote:

> + * Ethernet port config (0x00 is not present on IXP42X):
> + *
> + * logical port		0x00		0x10		0x20
> + * NPE			0 (NPE-A)	1 (NPE-B)	2 (NPE-C)
> + * physical PortId	2		0		1
> + * TX queue		23		24		25
> + * RX-free queue	26		27		28
> + * TX-done queue is always 31, RX queue is configurable

(Note that this assignment depends on the firmware, and different
firmware versions use different queues -- you might want to add a
note about which firmware version this holds for.)
