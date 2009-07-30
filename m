Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbZG3UFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbZG3UFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZG3UFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:05:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbZG3UFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:05:01 -0400
Date: Thu, 30 Jul 2009 12:52:29 -0700
From: Greg KH <gregkh@suse.de>
To: Nicolas Palix <npalix@diku.dk>
Cc: hjanssen@microsoft.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: hv: Replace typedef SG_BUFFER_LIST by struct
 scatterlist
Message-ID: <20090730195229.GB27953@suse.de>
References: <200907301737.23849.npalix@diku.dk>
 <20090730155844.GB20557@suse.de>
 <Pine.LNX.4.64.0907302020250.13698@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907302020250.13698@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 08:35:08PM +0200, Nicolas Palix wrote:
> On Thu, 30 Jul 2009, Greg KH wrote:
> 
> > On Thu, Jul 30, 2009 at 05:37:23PM +0200, Nicolas Palix wrote:
> >>
> >> typedef SG_BUFFER_LIST is removed and its uses are replaced by the use of
> >> struct scatterlist.
> >
> > Sweet!  thanks for doing this, very nice job, I'll go queue it up.
> 
> I tried to change the RingBuffer too but I did not know
> which API I should use.
> The ring buffer in kernel/trace seems fine but it has some
> dedicated features.
> 
> Any hint?
> Of which infrastructure are you thinking in your previous mail?

I was thinking of include/linux/ring_buffer.h

Does that not work for you?

thanks,

greg k-h
