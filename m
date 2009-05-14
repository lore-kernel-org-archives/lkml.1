Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZENUYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZENUYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZENUXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:23:53 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:55198 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbZENUXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cTqrMfsTM0a+LUhfOkqrOtV4PLztKlFYRertWxPVwFGBujnjfbN2o3G7FaiF6+b+Of
         OCYqvV2LZs7ZPI9BeDXSPW1GWW7w6GCkeCdNXfbwDZPsfa1OWOFEgbjnSJMyTBF5tWJq
         i0OqveZSX+EU3y3yLFk6/GkvMNd4aS+yVvNSc=
MIME-Version: 1.0
Reply-To: Tobias_Mueller@twam.info
In-Reply-To: <20090515010947.4016ba66.const@mimas.ru>
References: <17be05570905130710s1192729cqafa09127f6c34bf9@mail.gmail.com>
	 <20090513151415.6e84fd82.akpm@linux-foundation.org>
	 <17be05570905140208n5fd695aayfad221808f70ac21@mail.gmail.com>
	 <20090515010947.4016ba66.const@mimas.ru>
Date: Thu, 14 May 2009 22:23:51 +0200
X-Google-Sender-Auth: abdcf29834042d98
Message-ID: <17be05570905141323l31ee6f9o71698e57aec4b698@mail.gmail.com>
Subject: Re: [PATCH 001/001] leds: alix-leds2 fixed for Award BIOS
From: =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
To: Constantin Baranov <const@mimas.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/14 Constantin Baranov <const@mimas.ru>:
> Do these boards support DMI? In that case, I suggest to write another
> function, say alix_award_present(). It shall first check DMI and then

Unfortunately, they don't.

I already searched the BIOS for characteristical strings, but it
seems to be there very basic version of Award BIOS. f It had a
characteric string or something like that then I had adjustet
alix_present(), because at the moment the force=1 parameter
is needed on boards with Award BIOS.
