Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYGWANQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYGWANQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 20:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYGWAM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 20:12:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:33326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbYGWAM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 20:12:58 -0400
Date: Tue, 22 Jul 2008 17:10:43 -0700
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [USB boot crash, -git] ecm_do_notify(), list_add corruption.
	prev->next should be next (ffff88003b8f82f8)
Message-ID: <20080723001043.GB8477@suse.de>
References: <20080721223038.GA2051@suse.de> <20080722134042.GA14315@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722134042.GA14315@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 03:40:42PM +0200, Ingo Molnar wrote:
> 
> hi Greg, David,
> 
> -tip randconfig boot testing just found this USB boot crash regression:
> 
> dummy_udc dummy_udc: enabled ep-a (ep1in-bulk) maxpacket 512
> dummy_udc dummy_udc: enabled ep-b (ep2out-bulk) maxpacket 512

Wierd, if we don't have the hardware, this shouldn't be a problem, right
David?

thanks,

greg k-h
