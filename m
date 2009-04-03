Return-Path: <linux-kernel-owner+w=401wt.eu-S1764311AbZDCOom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764311AbZDCOom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764106AbZDCOo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:44:29 -0400
Received: from mga06.intel.com ([134.134.136.21]:63948 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756811AbZDCOo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:44:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503327925"
Subject: Re: [PATCH] leds: Increase trigger name maximum size
From: Richard Purdie <rpurdie@linux.intel.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <49D536FA.2050307@lwfinger.net>
References: <49d5059a.f3z10uf0HvyIItSz%Larry.Finger@lwfinger.net>
	 <49D536FA.2050307@lwfinger.net>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 15:45:04 +0100
Message-Id: <1238769904.5347.11.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-04-02 at 17:06 -0500, Larry Finger wrote:
> Larry Finger wrote:
> > On my HP dv2815 laptop, the total length of the triggers for my b43legacy
> > wireless device exceeds the maximum value of 50 defined in
> > include/linux/leds.h. As a result, the list is garbled.
> > 
> > Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> > ---
> 
> Richard,
> 
> Please drop this. That length change is a red herring. Something is corrupting
> the list of triggers, but this length is not it.
> 
> Sorry for the noise.

I was about to raise some concerns about this patch as its just hiding
some underlying memory corruption. I don't think this is related to the
LED code but let me know if it turns out to be.

Cheers,

Richard
-- 
Richard Purdie
Intel Open Source Technology Centre

