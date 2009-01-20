Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbZATWla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbZATWla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbZATWlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:41:20 -0500
Received: from ns2.suse.de ([195.135.220.15]:40123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbZATWlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:41:19 -0500
Date: Tue, 20 Jan 2009 14:39:57 -0800
From: Greg KH <gregkh@suse.de>
To: Christian Lamparter <chunkeey@web.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Artur Skawina <art.08.09@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Linux wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH -stable] p54usb: fix traffic stalls / packet drop
Message-ID: <20090120223957.GA6088@suse.de>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.vUD.KKRdJB@chimera> <200901202311.11854.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901202311.11854.chunkeey@web.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 11:11:11PM +0100, Christian Lamparter wrote:
> All p54usb devices need a explicit termination packet, in oder to finish the pending transfer properly.
> Else, the firmware could freeze, or simply drop the frame.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> Cc: stable <stable@kernel.org>
> ---
> Attached is the patch is for the stable series only.
> Bugzilla reference: http://bugzilla.kernel.org/show_bug.cgi?id=12260
> (wireless-testing needs a different one)

What do you mean, this is for 2.6.28-stable or 2.6.27-stable only, and
not 2.6.29?  Why?

thanks,

greg k-h
