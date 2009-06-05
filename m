Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbZFEOVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbZFEOVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZFEOVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:21:41 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:52686 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZFEOVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:21:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Uw1sA4LrYobBbL5TVMvgVtBJcdDXx3XvcLY/cahTWKZCEYenVKGawqw3hc0hPgcmii
         qXUMTANIAlOia4aKmn9t5F1lOUmmhujUAaGQ8sZDJU4bFkg0DUZJKlPWXxabR7yosDLo
         aILWlUQxK0rOIPZfvAPbEH1ZNrdd51N4jMWhs=
MIME-Version: 1.0
In-Reply-To: <4A2925F8.6060602@openwrt.org>
References: <1244204510-14007-1-git-send-email-me@bobcopeland.com>
	 <4A2925F8.6060602@openwrt.org>
Date: Fri, 5 Jun 2009 10:21:42 -0400
X-Google-Sender-Auth: 016d249de747652d
Message-ID: <b6c5339f0906050721k1ed672a0xf6123fa092cb76dd@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix minstrel single-rate memory corruption
From: Bob Copeland <me@bobcopeland.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, rathamahata@gmail.com,
       ognjen.maric@gmail.com, rjw@sisk.pl, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 10:04 AM, Felix Fietkau<nbd@openwrt.org> wrote:
>> John & Felix, the patch itself may be too subtle so feel free to do it a
>> different way.  However this is as minimal as it gets so I hope it can
>> be applied quickly to stable, and mainline if not too late.
>
> How about changing the type of sample_idx to signed instead of casting
> it? It's just a cosmetic thing, so even if you leave at this you get my

Yeah, that is a better option for 2.6.31.  I would be a bit more
comfortable with this version for now though since it's exactly
the code I tested.

> Acked-by: Felix Fietkau <nbd@openwrt.org>

Thanks!

-- 
Bob Copeland %% www.bobcopeland.com
