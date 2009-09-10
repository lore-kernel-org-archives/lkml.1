Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZIJCVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZIJCVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 22:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbZIJCVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 22:21:07 -0400
Received: from relay1.sgi.com ([192.48.179.29]:38145 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751651AbZIJCVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 22:21:06 -0400
Date: Wed, 9 Sep 2009 21:21:02 -0500
From: Jack Steiner <steiner@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Daniel Walker <dwalker@fifo99.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: SGU UV Add volatile to macros that access chipset registers
Message-ID: <20090910022101.GA10038@sgi.com>
References: <20090909154246.GA26716@sgi.com> <1252512600.14793.125.camel@desktop> <20090909180110.GA10311@sgi.com> <1252519885.14793.135.camel@desktop> <4AA7F9E5.4070506@nortel.com> <20090909193829.GB10530@sgi.com> <4AA84BE7.9010304@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA84BE7.9010304@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 05:44:23PM -0700, H. Peter Anvin wrote:
> On 09/09/2009 12:38 PM, Jack Steiner wrote:
> >  
> >  static inline void uv_write_local_mmr8(unsigned long offset, unsigned char val)
> >  {
> > -	*((unsigned char *)uv_local_mmr_address(offset)) = val;
> > +	*((volatile unsigned char *)uv_local_mmr_address(offset)) = val;
> >  }
> >  
> 
> Why aren't you simply using __writeb() here, and the other memory
> accessors we already have in the other places?

Excellent idea. New patch to follow...


--- jack
