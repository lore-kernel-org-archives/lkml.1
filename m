Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbZBVTmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbZBVTmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 14:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZBVTmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 14:42:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:52725 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbZBVTmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 14:42:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EBuvfDBocspPahbCMZK3oSBMyxUmbf/D4U4MumsGOkzsEUjYedC13MyNibRt5qO0U6
         mgeCmZf9Ei9ZEfZOrTvBxHBtTvAY62VP+ae4fssVUzetn2B6TRBGKGRP1x/oyvnYKbBY
         5MyZdLOoSKPJjxmxIaDJf+R8axm6aPYvqs3y8=
Date: Sun, 22 Feb 2009 20:42:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>, Bob Copeland <me@bob>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090222194236.GA6060@nowhere>
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <20090222171032.GD6003@nowhere> <49A1A72A.50102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A1A72A.50102@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 08:27:38PM +0100, Jiri Slaby wrote:
> On 22.2.2009 18:10, Frederic Weisbecker wrote:
>> I have some troubles with kmemcheck, so I give up for now.
>> Well, by reading the kmemcheck documentation, it tells that there can be some false
>> positives so...
>
> This has nothing to do with kmemcheck.
>
>> Since we are not sure this is a real bug, I'm not sure it would be interesting.
>
> There is no false positive possibility with these checkers, so this is  
> pretty much interesting, because it is a bug.


If so, Documentation/kmemcheck.txt really needs an update.

