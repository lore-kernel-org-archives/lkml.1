Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbXISVa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbXISVa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbXISVaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:30:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45782 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbXISVaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:30:13 -0400
Date: Wed, 19 Sep 2007 23:30:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@myrealbox.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       kernel1@cyberdogtech.com
Subject: Re: A little coding style nugget of joy
Message-ID: <20070919213010.GG18707@one.firstfloor.org>
References: <20070919123401.9369534d.kernel1@cyberdogtech.com> <p73odfyvar1.fsf@bingen.suse.de> <46F19326.1040503@myrealbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F19326.1040503@myrealbox.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a terrible assumption in general (i.e. if filesize % blocksize 
> is close to uniformly distributed).  If you remove one byte and the data 
> is stored with blocksize B, then you either save zero bytes with 
> probability 1-1/B or you save B bytes with probability 1/B.  The 
> expected number of bytes saved is B*1/B=1.  Since expectation is linear, 
> if you remove x bytes, the expected number of bytes saved is x (even if 
> there is more than one byte removed per file).

You didn't calculate the probability of actually saving a full block 
or not (that's the only thing that matters). I assumed it's relatively
small and can be ignored in practice since the amount of end white
space is negligible compared to total file size.

-Andi
