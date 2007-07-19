Return-Path: <linux-kernel-owner+w=401wt.eu-S940559AbXGSTew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940559AbXGSTew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934381AbXGSTen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:34:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:19592 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933737AbXGSTem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:34:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=L5MokX9lwMiWTjWfyDzbHK3TKAg+km0Xl0u8cG5F4tjwvl6yZLduEQ11iSF+S0Et9OL2I9LmxPpY4JpJleSD+VEemZnrycRGNyB+RLyG1dWirG4u0N69SK1gPUS0g/O0vPjfcGXzTKniXPgUrF6JM5be6ibwc0GP8RU2m3jvvZM=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Date: Thu, 19 Jul 2007 20:34:35 +0100
User-Agent: KMail/1.8.2
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Rene Herman <rene.herman@gmail.com>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
References: <8FO1e-2jW-35@gated-at.bofh.it> <9a8748490707161554j1fa7625fq1f1cb7e6aa359715@mail.gmail.com> <Pine.LNX.4.58.0707170134390.29868@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0707170134390.29868@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707192034.35885.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007 00:42, Bodo Eggert wrote:
> > Please note that I was not trying to remove the 8K stack option right
> > now - heck, I didn't even add anything to feature-removal-schedule.txt
> > - all I wanted to accomplish with the patch that started this threas
> > was;  a) indicate that the 4K option is no longer a debug thing  and
> 
> Very ACK.
> 
> > b) make 4K stacks the default option in vanilla kernel.org kernels as
> > a gentle nudge towards getting people to start fixing the code paths
> > that are not 4K stack safe.
> 
> That's the big NACK. It's OK for MM, where things are supposed to be in a 
> not well-tested state, but for running possibly mission-critical systems,
> you should take no risk.

Mission-critical machines are not supposed to have kernel configured
with incompetent/careless sysadmin who didn't think about
config choices he made at kernel build time.
--
vda
