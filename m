Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbYFZGAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbYFZGAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 02:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYFZGAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 02:00:05 -0400
Received: from gw.goop.org ([64.81.55.164]:56880 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbYFZGAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 02:00:04 -0400
Message-ID: <48633057.1040106@goop.org>
Date: Wed, 25 Jun 2008 22:59:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Arjan van de Ven <arjan@infradead.org>, Dave Airlie <airlied@gmail.com>,
       Dave Airlie <airlied@linux.ie>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kmap_atomic_pfn for PCI BAR access?
References: <1214242487.11887.35.camel@koto.keithp.com>	 <4862EE4C.4060009@goop.org>	 <21d7e9970806251823q3405e192q13d4944bd0cc3291@mail.gmail.com>	 <20080625213603.0e82805b@infradead.org> <1214458589.1044.45.camel@koto.keithp.com>
In-Reply-To: <1214458589.1044.45.camel@koto.keithp.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Packard wrote:
> On Wed, 2008-06-25 at 21:36 -0700, Arjan van de Ven wrote:
>
>   
>> well kmap does a tlb flush as well... 
>>     
>
> kmap_atomic
>   

Anything that does any kind of pagetable manipulation needs to do tlb 
flushes.  kunmap_atomic handles the flushing.

    J
