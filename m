Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbZHSOTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbZHSOTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZHSOTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:19:08 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:36100 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751944AbZHSOTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:19:07 -0400
Date: Wed, 19 Aug 2009 16:18:59 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Dhaval Vasa <dhaval.vasa@einfochips.com>
Cc: nico@cam.org, linux-kernel@vger.kernel.org, rabeeh@marvell.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH v2] [ARM] Kirkwood: Marvell OpenRD-Base board support
 added to v2.6.31-rc5
Message-ID: <20090819161859.5546c627@marrow.netinsight.se>
In-Reply-To: <4A8C02E9.2090701@einfochips.com>
References: <1249906054-572-1-git-send-email-dhaval.vasa@einfochips.com>
	<20090819151814.7167bad0@marrow.netinsight.se>
	<4A8C02E9.2090701@einfochips.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 19:19:29 +0530
Dhaval Vasa <dhaval.vasa@einfochips.com> wrote:

> >> +static unsigned int openrd_base_mpp_config[] __initdata = {
> >> +	MPP29_GPIO,	
> >                    ^^^^^
> > There is trailing whitespace on this line
> > 
> Nicolas has already applied this patch on his orion tree; it would be 
> worth generating separate one for whitespace ?  Suggest.

Maybe not, I'm not sure what the procedure is. I didn't realise it was
already there - I was looking at another git tree :-)

> > Also, I'd suggest merging "[PATCH v2] Kirkwood: Initialise SATA for
> > OpenRD-Base" into this one and resubmit it.
> 
> Nicolas has already applied this patch on his orion tree.  Should I 
> re-submit now ?

Well, if it's already there I think it's fine as it is. I thought the
patch was still under consideration.

> Can you point me to your patch ?

I posted it about a month ago on this list, see:

  http://www.spinics.net/lists/arm-kernel/msg70680.html

I guess you can apply the patch I sent in the last mail to the Orion
tree if it's acceptable - that's basically the diff between my old
patch and the new one you sent.

// Simon
