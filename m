Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYAXBve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYAXBve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 20:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYAXBv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 20:51:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35657 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYAXBv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 20:51:26 -0500
Date: Wed, 23 Jan 2008 17:43:18 -0800
From: Greg KH <greg@kroah.com>
To: Paul Chavent <paul.chavent@fnac.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Usb generic serial.
Message-ID: <20080124014318.GB21978@kroah.com>
References: <47860FA7.1090501@fnac.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47860FA7.1090501@fnac.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 01:29:27PM +0100, Paul Chavent wrote:
> Hello and happy new year 2008.
>
> In drivers/usb/serial/usb-serial.c there is a function (fixup_generic / 
> set_to_generic_if_null) that hooks null fops to the generic driver ones.
>
> The drivers/usb/serial/generic.c implements throttle, unthrottle and 
> resume, but those aren't used by default in fixup_generic. Is there any 
> reasons ? Could we submit a patch for that ?

Do you have a driver that needs to use these throttle/unthrottle and
resume functions?  If so, we can change things to use them, but so far,
it hasn't been needed.

thanks,

greg k-h
