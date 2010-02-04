Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab0BDDRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:17:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:40373 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab0BDDRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:17:51 -0500
Message-ID: <4B6A3DED.6060708@kernel.org>
Date: Thu, 04 Feb 2010 12:24:29 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: Chandra Shekhar Sah <edu4madh@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: port multiplier problem
References: <4B5885F7.2020007@gmail.com> <4B679EA9.6030203@kernel.org>	 <4B6833DD.1020001@gmail.com> <4B683581.7070708@kernel.org>	 <4B683DEF.3000302@gmail.com>	 <da824cf31002020844r12cada26x57f96b0aa24b59c6@mail.gmail.com>	 <4B686B2B.2080406@gmail.com>	 <da824cf31002021104v72efcd05ne639091042d5999d@mail.gmail.com>	 <4B687B7C.2070406@gmail.com> <da824cf31002031837t1cf2357bsbb53a3b4ea5e671f@mail.gmail.com>
In-Reply-To: <da824cf31002031837t1cf2357bsbb53a3b4ea5e671f@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 03:17:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2010 11:37 AM, Grant Grundler wrote:
> I had two questions on that thread that never got answered:
>    http://markmail.org/message/snpekoj4qexrslk5
> 
> | How can we find out if anyone has the SEMB properly wired up?
> | Would it be hard to make libata aware of "SEMB port not responding" case?
> | ie if the SEMB port times out or has no link, reduce the port count of
> | the sil3726 PMP by one.
> |
> | Maybe add a "enable_sil24_semb" flag to libata?
> | (avoid checking unless someone asks for it). I hate magic flags but also
> | don't want to subject most people to the timeout delay.
> 
> I (or Gwendal) can post a patch (and lightly test) for any of the above.
> Just need to get some guidance so we don't waste our time.

It's not really sil24 tho.  But anyways, I think we can just disable
them altogether.  It's not like they have ever worked.  Just limiting
both 3726 and 4726 to 5 ports should be fine.  That said, I'm not
quite sure this is relevant to the reported problem but it's worth a
shot.

Thanks.

-- 
tejun
