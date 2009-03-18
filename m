Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbZCRPaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbZCRPaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZCRPaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:30:04 -0400
Received: from kroah.org ([198.145.64.141]:50220 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752088AbZCRPaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:30:03 -0400
Date: Wed, 18 Mar 2009 08:27:15 -0700
From: Greg KH <greg@kroah.com>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, davem@davemloft.net
Subject: Re: Next March 18: [staging/net ??] build break
Message-ID: <20090318152715.GB8655@kroah.com>
References: <20090318173830.7ea03dfb.sfr@canb.auug.org.au> <49C0D3BF.8060908@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C0D3BF.8060908@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 04:28:07PM +0530, Sachin Sant wrote:
> Today's Next randconfig build fails with
>
> drivers/staging/built-in.o: In function .ieee80211_xmit:
> (.text+0x69460): multiple definition of .ieee80211_xmit
> drivers/net/built-in.o:(.text+0x2557e0): first defined here
> ld: Warning: size of symbol .ieee80211_xmit changed from 3688 in 
> drivers/net/built-in.o to 2880 in drivers/staging/built-in.o
> drivers/staging/built-in.o: In function ieee80211_xmit:
> (.opd+0x2ff0): multiple definition of ieee80211_xmit
> drivers/net/built-in.o:(.opd+0xe980): first defined here
> make[1]: *** [drivers/built-in.o] Error 1

Known issue, don't build all the staging wireless drivers into the
kernel tree, you will get conflicting symbols like this.

People are working on this, but it's much lower priority as it isn't a
real use case.

thanks,

greg k-h
