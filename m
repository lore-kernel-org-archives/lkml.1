Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbYKKTnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbYKKTnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYKKTnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:43:37 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:16463 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbYKKTng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:43:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RS9KZpep2CK58GwFEzhsCuIjQhCfSZGARhpu0RJGIrdb28Pl3mo2OCR0tOUx3bRNpO
         NePqz/aaxMQJaKMhIz0t4/61EMjpm03Ci6O6mx1TvfLINU1GdSbYJP8GmEmufaEWzmj5
         MYUg6ZODvHMvokA2R7w54W6E6FkCwm4QgrkhA=
Date: Tue, 11 Nov 2008 14:43:30 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Jeremy Katz <katzj@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] psmouse: OLPC: fix incorrect validate_byte check
Message-ID: <20081111144239.ZZRA012@mailhub.coreip.homeip.net>
References: <1226093165.10798.19.camel@aglarond.local> <20081107033652.5f44001a@debxo> <1226345007.10798.188.camel@aglarond.local> <20081109074057.769a1c83@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109074057.769a1c83@debxo>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 07:40:57AM -0800, Andres Salomon wrote:
> Hm, you're right; does this patch fix it?  (Sorry for the top-posting,
> folks)
> 
> 
> 
> 
> The validate_byte check logic was backwards; it should return true for
> an *invalid* packet.  Thanks to Jeremy Katz for spotting this one.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>

Applied, thank you Andres.

-- 
Dmitry
