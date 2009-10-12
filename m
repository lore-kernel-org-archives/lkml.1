Return-Path: <linux-kernel-owner+w=401wt.eu-S932325AbZJLOdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbZJLOdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932312AbZJLOdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:33:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:46880 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311AbZJLOc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:32:59 -0400
Date: Mon, 12 Oct 2009 07:28:49 -0700
From: Greg KH <gregkh@suse.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH] USB: musb: invert arch depend string
Message-ID: <20091012142849.GA1114@suse.de>
References: <20091012074221.GA19198@elte.hu>
 <1255355396-20533-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255355396-20533-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 09:49:56AM -0400, Mike Frysinger wrote:
> The MUSB code relies on platform implementations that currently only
> exists for Arm and Blackfin processors, so have the MUSB Kconfig depend
> upon those arches.
> 
> This should prevent other arches from building MUSB via randconfig.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Linus, if you want to take this right now, feel free to add:

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Otherwise I will queue this up to send to you in a day or so.

thanks,

greg k-h
