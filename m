Return-Path: <linux-kernel-owner+w=401wt.eu-S1759657AbZKZLst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbZKZLst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 06:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758214AbZKZLss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 06:48:48 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:54623 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbZKZLss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 06:48:48 -0500
Message-ID: <4B0E6B02.8020705@collabora.co.uk>
Date: Thu, 26 Nov 2009 11:48:18 +0000
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, jeff@garzik.org
Subject: Re: 
References: <1259197403.2858.88.camel@calx>	 <1259232570-11918-1-git-send-email-ian.molton@collabora.co.uk> <1259235525.9212.444.camel@calx>
In-Reply-To: <1259235525.9212.444.camel@calx>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Thu, 2009-11-26 at 10:49 +0000, Ian Molton wrote:
>> Hi guys,
>>
> 
> No need to pass rng_buffer to the helper as there's only one with global
> scope.

Ah, sorry, I see what you mean now. The logic behind that is that it
matches the new API, whcih is all that will be left once the old drivers
are patched to use it. I planned to drop the helper altogether at that
point and though it'd make the patch more readable when that happens.

I can drop it if thats preferable, though.

Is this enough to get an acked-by: ? If so, I'll do that and see about
getting the change into linux-next.

Rusty: are you happy with the new version of virtio-rng ?

Cheers guys,

-Ian

