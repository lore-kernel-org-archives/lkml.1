Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbYIJWTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbYIJWTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYIJWTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:19:01 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:41502 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYIJWTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:19:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=W6JKh7pb1DOrkfKogb1x7tNWdQpqiGJzewjPlmjmEZo9YswRm4NLpYqd+1Y3wFO4wG
         hYF61IspjN1zSCM8r11KQhELNShYTlDJ8B/FJJ4aBVS9DgMCkMPmjW6Kp2E0V2kXOXoJ
         BkGaxgIhFmX2c8f+yxrjvXgibKsfVcTOlSlNM=
Message-ID: <43e72e890809101518k35047191hac8b796383a5638@mail.gmail.com>
Date: Wed, 10 Sep 2008 15:18:59 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH 1/2 v6] cfg80211: Add new wireless regulatory infrastructure
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1221084429.13336.23.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221027589-19203-1-git-send-email-lrodriguez@atheros.com>
	 <1221027589-19203-2-git-send-email-lrodriguez@atheros.com>
	 <1221070650.13336.20.camel@californication>
	 <43e72e890809101318o771100f0jcac9bbea6b863ccb@mail.gmail.com>
	 <1221084429.13336.23.camel@californication>
X-Google-Sender-Auth: 782eaf096b849e39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 3:07 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Luis,
>
>> > While reading through it, I came to think about regulatory_hint(). So is
>> > there a use case where would give it the alpha2 code and the domain
>> > itself at the same time? If not, then it would make more sense to split
>> > this into two functions.
>>
>> Nope, you either pass an alpha2 or an rd domain which is built by you
>> (and in that rd structure you can set the alpha2 to your iso3166
>> alpha2 or "99" if unknown).
>>
>> > Maybe something regulatory_alpha2_hint() and
>> > regulatory_domain_hint(). Just a thought.
>>
>> That's how I had it originally but decided to condense it to one
>> routine since as you could see they pretty much do the same thing
>> except the case where the rd is provided it calls set_regdom().
>> Setting it back to use two routines if fine by me too. What is better?
>> Can we just get this merged and then we can flip it around if
>> necessary? :) I'm tired of carrying this around.
>
> my take on this is that if from an API perspective you can only use one
> parameter or the other, then it should be two functions.

This is reasonable, I'll respin, yet once again...

  Luis
