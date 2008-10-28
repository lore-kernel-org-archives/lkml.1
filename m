Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYJ1T0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYJ1T0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYJ1T0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:26:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57352 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYJ1T0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:26:09 -0400
Date: Tue, 28 Oct 2008 20:27:44 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w35und: usb_put_dev() is missing from wb35_disconnect()
Message-ID: <20081028192744.GF16452@elf.ucw.cz>
References: <Pine.LNX.4.64.0810272328430.8946@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810272328430.8946@melkki.cs.Helsinki.FI>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-10-27 23:29:31, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The wb35_probe() function does usb_get_dev() so add a missing usb_put_dev() to
> the wb35_disconnect() function. Also fix error handling paths in wb35_probe()
> to call usb_put_dev() as well.

Acked-by: Pavel Machek <pavel@suse.cz>

...and thanks for all the patches. I don't think I ever tested module
removal on this one...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
