Return-Path: <linux-kernel-owner+w=401wt.eu-S1764019AbYJJUUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764019AbYJJUUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762361AbYJJUTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:19:48 -0400
Received: from kroah.org ([198.145.64.141]:43701 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762315AbYJJUTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:19:47 -0400
Date: Fri, 10 Oct 2008 13:16:39 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: stable@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [stable] [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in
	used_vectors bitmap
Message-ID: <20081010201639.GB32164@kroah.com>
References: <48EFB4B2.2020508@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EFB4B2.2020508@canonical.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 04:01:54PM -0400, Stefan Bader wrote:
> Affected: 2.6.24-2.6.27
> 
> Someone from the community found out, that after repeatedly unloading and
> loading a device driver that uses MSI IRQs, the system eventually assigned
> the vector initially reserved for IRQ0 to the device driver.

"Someone"?  do you have a name or pointer to the person/bugreport so
that they can be properly credited?

thanks,

greg k-h
