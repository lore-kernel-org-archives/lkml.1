Return-Path: <linux-kernel-owner+w=401wt.eu-S933147Ab0AFXxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab0AFXxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933081Ab0AFXxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:53:21 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:47501 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979Ab0AFXxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:53:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BZL7DzX19fOPX7zS09m4+H73s2JHMINZ2HkFdWQ6M9wHuOV3jFLDPJoSj1SYvwb5TR
         LyQlzWReE2hPtjZMmMmOn0VkOhVnPkiQS2+Nw8vtNX2HcF/YxsmdsMqq0hvUbLAJxMDe
         JNriNHCoOfEA1Wy8wbpWYRq/CHQ8waNj/fNFA=
MIME-Version: 1.0
In-Reply-To: <20100106083214.DAAA933C5F5@tippex.mynet.homeunix.org>
References: <20100105110256.D2DF133C4B0@tippex.mynet.homeunix.org>
	 <4B43DF97.7080208@gmail.com>
	 <20100106083214.DAAA933C5F5@tippex.mynet.homeunix.org>
Date: Wed, 6 Jan 2010 17:53:19 -0600
Message-ID: <51f3faa71001061553q29e0821evda63c4ca3eeee3b1@mail.gmail.com>
Subject: Re: Memory probing fails after 2.6.30 (bisected)
From: Robert Hancock <hancockrwd@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 2:32 AM, Anders Eriksson <aeriksson@fastmail.fm> wrote:
>
> hancockrwd@gmail.com said:
>> Think you missed posting which was the actual bad commit it reported?
>
> The last one in the list:
> 8ecee4620e76aae418bfa0e8cc830e92cb559bbb
>
> That's a merge commit. How do i dig futher into that? My git-fu is lacking...

AFAIK, the bisect shouldn't land on a merge commit unless the changes
in the commit itself are what are causing the problem, and the merge
commit itself doesn't have any changes. Is it possible something went
wrong in the bisect and one of your good/bad results was incorrect?
