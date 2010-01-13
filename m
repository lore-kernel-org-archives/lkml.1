Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230Ab0AMVer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab0AMVer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862Ab0AMVeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:34:46 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:43902 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab0AMVeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:34:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AiATHI1rgoEyb+kBouEiRQm8LWXwe7/w9JMCtkklAnXljkuzARnXLeqT1Q7fXG3792
         wIMw9vZ2vnEgYz5o4K97MdQTaHrxT4mWOZq7v1vrSzGx5C02bX7NKGGoaeWXig1+TFAT
         VZxvENYf80sT+VmjzgGiS94NUKIzK8dQczto0=
Date: Wed, 13 Jan 2010 22:34:36 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100113213435.GB3065@del.dom.local>
References: <20100108074539.GA6205@ff.dom.local>
 <4B475FF9.7000702@majjas.com>
 <20100108212923.GA3078@del.dom.local>
 <4B47A81B.5040601@majjas.com>
 <4B4809EF.1070609@majjas.com>
 <20100109122830.GA4386@del.dom.local>
 <4B48CC2C.2090403@majjas.com>
 <4B4E2F89.2050606@majjas.com>
 <20100113210908.GA3065@del.dom.local>
 <4B4E3834.3000609@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4E3834.3000609@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 04:16:36PM -0500, Michael Breuer wrote:
> If it helps, I'm still getting one error without DMAR enabled - at
> startup, there's a DMA sync oops - mismatch of 72 bytes coming from
> sky2. That oops was posted previously - with DMAR (re) enabled,
> there's no related oops.

I hope re-posting this oops with this information should be helpful.

Jarek P.
