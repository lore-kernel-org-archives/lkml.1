Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbZHSPp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbZHSPp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 11:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZHSPp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 11:45:58 -0400
Received: from kroah.org ([198.145.64.141]:58512 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbZHSPp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 11:45:58 -0400
Date: Wed, 19 Aug 2009 08:44:37 -0700
From: Greg KH <greg@kroah.com>
To: Karl Relton <karllinuxtest.relton@ntlworld.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/wlan-ng: Convert firmware loading to load
 binary ihex format
Message-ID: <20090819154437.GA729@kroah.com>
References: <1250665599.4545.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250665599.4545.3.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 08:06:39AM +0100, Karl Relton wrote:
> Convert prism2_usb firmware loading to load firmware in pre-compiled
> binary 'ihex' format rather than ascii 'srec' format. This moves the
> srec processing and sorting of records out of kernel space into a
> pre-compiler. The driver now just works with the binary image, but
> still does the 'pda plugging' of that image at runtime, as required
> by the prism hardware.
> 
> Signed-off-by: Karl Relton <karllinuxtest.relton@ntlworld.com>


Are the firmware images updated somewhere?  Like in the linux-firmware
tree?

thanks,

greg k-h
