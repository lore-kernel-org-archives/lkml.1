Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343Ab0AMVJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab0AMVJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:09:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469Ab0AMVJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:09:15 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:39212 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab0AMVJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:09:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h1+zcN/eGnIuk4ymxoBkS+pnUQDK8Kl1JbT72LYlmiluMV7z7It0eeSxCG1024Fty5
         AcNEDzwhxSxFT7UgN1DpSdHT32gJIvTlS2FhKKlgfjD+3KzpC5u1HIUMrsR5VPoWDD99
         OR457yoSY61b1XC7KwNUFs9OZ+DfICZdEVLW4=
Date: Wed, 13 Jan 2010 22:09:08 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100113210908.GA3065@del.dom.local>
References: <20100107185040.GB3208@del.dom.local>
 <4B466A26.5070506@majjas.com>
 <20100108074539.GA6205@ff.dom.local>
 <4B475FF9.7000702@majjas.com>
 <20100108212923.GA3078@del.dom.local>
 <4B47A81B.5040601@majjas.com>
 <4B4809EF.1070609@majjas.com>
 <20100109122830.GA4386@del.dom.local>
 <4B48CC2C.2090403@majjas.com>
 <4B4E2F89.2050606@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4E2F89.2050606@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 03:39:37PM -0500, Michael Breuer wrote:
> Just an FYI - 2.6.32.3 with alt 3 af_packet patch & sky2
> pskb_may_pull runs OK with DMAR (re)enabled and msi enabled.

Hmm... What a pity! It was such a useful debugging tool for
networking ;-) BTW, I'm not sure if "runs OK" means with or without
those DHCP drops & large packets you described.

Thanks,
Jarek P.
