Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbZDUUXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbZDUUXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 16:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZDUUXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 16:23:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbZDUUXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:23:34 -0400
Date: Tue, 21 Apr 2009 13:20:36 -0700
From: Greg KH <gregkh@suse.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH] go7007: Convert to the new i2c device binding model
	(v2)
Message-ID: <20090421202036.GA9343@suse.de>
References: <20090421212430.57819f8f@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421212430.57819f8f@hyperion.delvare>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 09:24:30PM +0200, Jean Delvare wrote:
> Move the go7007 driver away from the legacy i2c binding model, which
> is going away really soon now.
> 
> The I2C addresses of the audio and video chips in s2250-board didn't
> look quite right, apparently they were left-aligned values when Linux
> wants right-aligned values, so I fixed them too.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
> Note: I just pushed this to Linus, as this is blocking the removal of
> the legacy i2c binding model, and I see no point in waiting for a
> driver which clearly doesn't work today anyway.

No objection from me, feel free to add my:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
if you need it.

thanks,

greg k-h
