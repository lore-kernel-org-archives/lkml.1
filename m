Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbZENJIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbZENJIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZENJIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:08:45 -0400
Received: from mail-pz0-f115.google.com ([209.85.222.115]:61645 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZENJIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:08:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qipaKZhi0jKflj7yun+Z8UgsbklrVhcgC+Kg7hWXjYpJlfH0ov8aAUD9m6hjfC9ugW
         ga5o6AKfRObLFZcly7rQ7oayRV/iiJb5ZjM8yBGq6L5nTVULj4RbOlarvxu175xmLNN7
         I8RomT21cibEuVeBohggyOQiH1xAg5uA04wgI=
MIME-Version: 1.0
Reply-To: Tobias_Mueller@twam.info
In-Reply-To: <20090513151415.6e84fd82.akpm@linux-foundation.org>
References: <17be05570905130710s1192729cqafa09127f6c34bf9@mail.gmail.com>
	 <20090513151415.6e84fd82.akpm@linux-foundation.org>
Date: Thu, 14 May 2009 11:08:45 +0200
X-Google-Sender-Auth: 7dc70d7bbf513df9
Message-ID: <17be05570905140208n5fd695aayfad221808f70ac21@mail.gmail.com>
Subject: Re: [PATCH 001/001] leds: alix-leds2 fixed for Award BIOS
From: =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
       Constantin Baranov <const@mimas.ru>,
       =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/14 Andrew Morton <akpm@linux-foundation.org>:
> Will this cause problems on boards which are _not_ running that BIOS?
No. These initialisations is already done there by BIOS, but setting
the registers twice doesn't matter. It's just configurating these pins
as an output.

> IOW, is this change backward-compatible?
Yes.
