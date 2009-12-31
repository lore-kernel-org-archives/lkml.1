Return-Path: <linux-kernel-owner+w=401wt.eu-S1751101AbZLaLkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101AbZLaLkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 06:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbZLaLka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 06:40:30 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:32399 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZLaLk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 06:40:29 -0500
Date: Thu, 31 Dec 2009 12:40:25 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] USB: mct_u232: fix DMA buffers on stack
Message-ID: <20091231114025.GE15063@localhost>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
 <1262037718-31424-10-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262037718-31424-10-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please disregard this one as I just realised that this has already been
fixed by Pete Zaitcev (in Greg's patch tree). The patches basically only
differs in that I added error messages for failed allocations, and
that Pete used put_unaligned for the divsor.

Sorry about that.

/Johan

