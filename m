Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbYGaUkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbYGaUkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbYGaUj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:39:56 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:49898 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbYGaUjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pVynTrZTLmpK4EzgTkEYU9ZBrwF1ZtF3RbX9jfkN/lyQqpbQxgsc4RRsAtAqdQTDDL
         4JtyQNy3F1AOZYyAFBf1qXfitOqerdL2kVppoUb4TqkgL0TkGjrrNY57QkRWctwl5goW
         QQJ80/Ny4zUvkDcA1KtCR2EBtjbB+ddqcxL8k=
Date: Thu, 31 Jul 2008 16:39:44 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
Message-ID: <20080731163738.ZZRA012@mailhub.coreip.homeip.net>
References: <20080731104437.5e5669bc.akpm@linux-foundation.org> <20080731141302.ZZRA012@mailhub.coreip.homeip.net> <200807312048.57575.rjw@sisk.pl> <20080731145023.ZZRA012@mailhub.coreip.homeip.net> <alpine.LFD.1.10.0807311207000.3277@nehalem.linux-foundation.org> <20080731151625.ZZRA012@mailhub.coreip.homeip.net> <alpine.LFD.1.10.0807311235350.3277@nehalem.linux-foundation.org> <20080731155701.ZZRA012@mailhub.coreip.homeip.net> <alpine.LFD.1.10.0807311310090.3277@nehalem.linux-foundation.org> <alpine.LFD.1.10.0807311318580.3277@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807311318580.3277@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 01:28:37PM -0700, Linus Torvalds wrote:
> 
> +				/* Some people get confused about size in bits vs bytes */
> +				if (size >= len/8)
> +					size = size/8;

People usually allocate single buffer (big enough) and the do a bunch
of tests so this condiion is likely to fire on EV_SW and similar event
types. I think it is safer to explicitely test for EV_KEY/0x1ff.

-- 
Dmitry
