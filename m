Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbYHDDDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbYHDDDD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 23:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbYHDDCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 23:02:53 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:60629 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbYHDDCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 23:02:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oPe2tDNV6BOkeWwWxaKBFKheaGgXO5PiAJpK+lN/H/W7g08Dos7QpB5pvW0N8/ttXs
         AMn2F4fabTfUbvQp7wtJaTTE2K0FxwmKPGUUydSoC5pQ6bEYi1pa/szvhed3KimSjkkj
         X9SKgcZDcuIsua7PAcGaXlSnwGMD1BwevBuII=
Message-ID: <a8e1da0808032002u6ba000f8j8b56991985d65b94@mail.gmail.com>
Date: Mon, 4 Aug 2008 11:02:49 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k : ath5k_config_interface deadlock fix
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Jiri Slaby" <jirislaby@gmail.com>, johannes@sipsolutions.net,
       tomasw@gmail.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linville@tuxdriver.com, stable@kernel.org
In-Reply-To: <b6c5339f0808010643i58dbb2a7jf459359451061ae4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080801074014.GA3341@darkstar> <4892C2CA.7010003@gmail.com>
	 <4892C359.9000304@cs.helsinki.fi>
	 <20080801011415.ff4821a3.akpm@linux-foundation.org>
	 <b6c5339f0808010643i58dbb2a7jf459359451061ae4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2008 at 9:43 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, Aug 1, 2008 at 4:14 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Fri, 01 Aug 2008 11:03:37 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>
>>> Jiri Slaby wrote:
>>> > Dave Young napsal(a):
>>> >> In the drivers/net/wireless/ath5k/base.c, there's recursive locking of
>>> >> sc->lock
>>> >
>>> > Should be fixed already:
>>> > http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commitdiff_plain;h=bc05116ab33d30342e2b4b1bcc6d6e1184e9df97
>>>
>>> I guess that didn't make it to -stable?
>>
>> (cc stable!)
>
> Not to worry, the commit that introduced it was
> 9d139c810a2aa17365cc548d0cd2a189d8433c65, which as far as I can tell
> came in after 2.6.26.

Strange, I get system stuck in 2.6.26 as well, so there might be other bugs.


>
> --
> Bob Copeland %% www.bobcopeland.com
>



-- 
Regards
dave
