Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYGOFwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYGOFwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbYGOFwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:52:05 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:19515 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556AbYGOFwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:52:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=H/ko+5sFvlSHVm436Rg13dpPvvchfrTNZCwlaK1i/BzpaNSSq7jvPdJipIRM+0DOEz
         1glFnaBIZZNYEmGUjtrjzxvWTGrO2NewXefzYuX2IQhf4nuC0gKjO45VzUm6fWd9gxSo
         WKFsWbRX+eynAgL79Wz0lNQjId/3ow4zz+SjM=
Message-ID: <a8e1da0807142251p14324917w62d751bed5a56b92@mail.gmail.com>
Date: Tue, 15 Jul 2008 13:51:56 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Mattias Nissler" <mattias.nissler@gmx.de>
Subject: Re: mac80211 : WARN at net/mac80211/rate.h:153
Cc: "Michael Buesch" <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Stefano Brivio" <stefano.brivio@polimi.it>
In-Reply-To: <1216055849.4435.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080714075010.GA3559@darkstar> <200807141614.51628.mb@bu3sch.de>
	 <1216055849.4435.7.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 1:17 AM, Mattias Nissler <mattias.nissler@gmx.de> wrote:
> On Mon, 2008-07-14 at 16:14 +0200, Michael Buesch wrote:
>> CCing PID guys.
>> I've seen several people hitting this. What's the meaning of this warning?
>
> It basically means the rate control cannot find any rate in
> local->hw.wiphy->bands[local->hw.conf.channel->band] that is supported
> by the sta in question. Normally this should not happen. I guess the
> reason is that the supported rates bits in the sta info are all zero,
> which would probably be a bug. I haven't seen this here, but I don't use
> the IBSS code either. To further investigate this, you could the
> following just before the WARN_ON:
>
> printk(KERN_DEBUG "supported rates bitmask: %08x\n",
>        sta->supp_rates[sband->band]);

Yes, as you said, I get:

supported rates bitmask: 00000000

>
> Mattias
>
>



-- 
Regards
dave
