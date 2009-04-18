Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbZDRX2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbZDRX2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 19:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759501AbZDRX2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 19:28:30 -0400
Received: from kroah.org ([198.145.64.141]:36301 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759182AbZDRX22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 19:28:28 -0400
Date: Sat, 18 Apr 2009 16:25:33 -0700
From: Greg KH <greg@kroah.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH/RFC 01/16] platform: Make platform resources input
	parameters const
Message-ID: <20090418232533.GB23201@kroah.com>
References: <1240080744-14995-1-git-send-email-geert@linux-m68k.org> <1240080744-14995-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240080744-14995-2-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 08:52:09PM +0200, Geert Uytterhoeven wrote:
> Make the platform resources input parameters of platform_device_add_resources()
> and platform_device_register_simple() const, as the resources are copied and
> never modified.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

If you need this for your other patches, no objection from me, feel free
to take it through your tree (or I can take it through mine if you
want.)

Either way, feel free to add:
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

to it.

thanks,

greg k-h
