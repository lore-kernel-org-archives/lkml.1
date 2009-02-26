Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbZBZXT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbZBZXT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 18:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZBZXTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 18:19:17 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:35280 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbZBZXTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 18:19:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hQdAngbe70drMu4Ia7DkDY0wzYYDXigH5CPYpa42BB4IwwzqIlojxYkTwje9fdLqRe
         ikVUlldwNzJHLoUG3fzSYAm1j2cF6l5L1qpQGSMNuKhhbCaVZUjYWy6R1spHdAkpnvBt
         YBQH934Aa9DAYkwV+YvGZiL4xf/1aDCbMpItw=
Message-ID: <49A7236E.2020807@gmail.com>
Date: Fri, 27 Feb 2009 00:19:10 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com> <20090226230338.M86894@bobcopeland.com>
In-Reply-To: <20090226230338.M86894@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.2.2009 00:15, Bob Copeland wrote:
> Speaking of, I think there's another potential oob array access at:
>
> if (rxs.rate_idx>= 0&&  rs.rs_rate ==
>      sc->curband->bitrates[rxs.rate_idx].hw_value_short)
>          rxs.flag |= RX_FLAG_SHORTPRE;
>
> because sc->rate_idx is u8 instead of s8.

strcmp("sc->rate_idx", "rxs.rate_idx") != 0 :)

Or did I miss something?
