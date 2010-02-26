Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965328Ab0BZQcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:32:42 -0500
Received: from ist.d-labs.de ([213.239.218.44]:44834 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965288Ab0BZQck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:32:40 -0500
Date: Fri, 26 Feb 2010 17:32:30 +0100
From: Florian Mickler <florian@mickler.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v2 2/2] enhance sysfs rfkill interface
Message-ID: <20100226173230.0479bf94@schatten.dmk.lab>
In-Reply-To: <1267189882.18491.63.camel@violet>
References: <20100225233516.GD5218@khazad-dum.debian.net>
	<1267182094-15469-1-git-send-email-florian@mickler.org>
	<1267189882.18491.63.camel@violet>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 14:11:22 +0100
Marcel Holtmann <marcel@holtmann.org> wrote:

> Hi Florian,
> > blocked_[hs]w -> 0/1 makes IMO kind of sense.
> 
> the kernel and /dev/rfkill just talks about "hard" and "soft" blocks.
> 
> Don't confuse this with hardware and software. It seems were are keeping
> to make this stupid semantical error over and over again. So everything
> that says hardware, software, hw or sw in the API is bluntly wrong.
> 
> Regards
> 
> Marcel
> 

Yes, ok. I agree that 'hardware block' for something 'out of
the control of the driver' seems to be too narrow...

Alright. How about blocked_soft and blocked_hard?

cheers,
Flo

