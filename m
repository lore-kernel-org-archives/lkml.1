Return-Path: <linux-kernel-owner+w=401wt.eu-S932518AbYDPT0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbYDPT0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYDPT0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:26:04 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:54280 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYDPT0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Vzw1EH/Gimen1gTBp2ZTiWOlQeVVNBGkgrO2hrJEi/ymMh5uIao15LlrIsQ/DKuXzx0TIvX6HftxqLGn4duBRtRnJ4gXQgRWCSHOhePRSZI1+hN5j/7ojrG9uAVZLem6oAeW+Y5Qf1/EOsjawPssBFqwkQok6JAMRHMC6Nd8gwQ=
Message-ID: <480651E2.4060907@gmail.com>
Date: Wed, 16 Apr 2008 21:22:10 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 and DEBUG_SECTION_MISMATCH
References: <20080416175135.GN1677@cs181133002.pp.htv.fi>
In-Reply-To: <20080416175135.GN1677@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

> Hi Sam,
> 
> although DEBUG_SECTION_MISMATCH allows to also find exotig things like 
> finding bugs only present when using gcc < 3.4 and CONFIG_HOTPLUG=n at 
> the same time, the problem is that we print
>     WARNING: modpost: Found 13 section mismatch(es).
>     To see full details build your kernel with:
>     'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> but CONFIG_DEBUG_SECTION_MISMATCH is not offered in 2.6.25.

Most of those ,,old mismatches'' where already fixed, so ...

> The options seem to be:
> - going back to the worse but for most practical purposes usable
>   warnings in 2.6.24
> - don't show these warnings during modpost for 2.6.25

... IMO it would be better to not show modpost warnings. It will result in great
number of reports from users. Sam is here a boss.

There's also second part of the story around inline functions which may be
reported while running with CONFIG_DEBUG_SECTION_MISMATCH.

Greats,
	Jacek
