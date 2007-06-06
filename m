Return-Path: <linux-kernel-owner+w=401wt.eu-S934830AbXFFS2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934830AbXFFS2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759672AbXFFS2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:28:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759067AbXFFS2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:28:04 -0400
Date: Wed, 6 Jun 2007 11:27:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Robert Hancock <hancockr@shaw.ca>, Gabriel C <nix.or.die@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070606112722.544adf13.akpm@linux-foundation.org>
In-Reply-To: <4666FA92.202@shadowen.org>
References: <fa.463099pz3wyAW1RRKsHFuX299RE@ifi.uio.no>
	<fa.zIhbKpmFY9tR8ro0OTwpTvD79Xk@ifi.uio.no>
	<4666C640.5040408@shaw.ca>
	<4666FA92.202@shadowen.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 19:18:58 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> >> http://frugalware.org/~crazy/other/mm/2.6.22-rc4-mm1/config
> >>
> >> Regards,
> >>
> >> Gabriel
> > 
> > Presumably because:
> > 
> > # CONFIG_PCI_GOMMCONFIG is not set
> > 
> > I'll cook up a patch later today.
> 
> This one is affecting machines in TKO noce that the e820 problem is fixed.

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/hot-fixes/revert-mmconfig-validate-against-acpi-motherboard-resources.patch
should fix that.
