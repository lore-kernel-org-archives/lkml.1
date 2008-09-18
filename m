Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYIRXL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYIRXL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbYIRXK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:10:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:11034 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbYIRXK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:10:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Bz1Go4CUmr4ciu8O2ROcKJgWpSZlQtoUUAR/vKD3gcBZaFiEJrtUUX97P39kTxtpGY
         m9NdiUEMK/9NobLLtmMC952Wu37APrPPbkLa08D+iPVWQ3xextjDB8lRrU7GMeNP179m
         4hdCRpL/6fGfvZ2obnwW2uLwKW2sqmgWqHO04=
Message-ID: <43e72e890809181610h3a7729d8s4c8484d97b21932e@mail.gmail.com>
Date: Thu, 18 Sep 2008 16:10:52 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
	 <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
	 <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com>
	 <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com>
	 <43e72e890809181344q416b5944w3332ee5a33db048c@mail.gmail.com>
	 <f488382f0809181449x7343aa7endff066cb5836a73c@mail.gmail.com>
	 <20080918220102.GE7408@tesla>
	 <43e72e890809181508w5232a14ewbf2bf18fe90a92d5@mail.gmail.com>
	 <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
X-Google-Sender-Auth: f4828fd4ced043f9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 4:04 PM, Steven Noonan
> I always get "1 megabit/sec". It actually measures (at best) to be a
> throughput of 8mbits/sec, though the average (due to strange random
> packet loss) is about 4mbits/sec. --

Yeah, iwconfig reports a wrong rate, should be easy to fix but I
haven't yet looked at it. If you can fix it it'd be appreciated.

> And that was with aggregation
> re-enabled via your patch.

That patch just fixes aggregation for mac80211 after the TX MQ
changes, its seems ath9k aggregation is broken. Looking into that now.

> Without, it never exceeds 1mbit/sec
> (actual, not just as indicated by iwconfig.

Right.

  Luis
