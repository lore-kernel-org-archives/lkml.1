Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZIUQpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZIUQpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbZIUQpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:45:23 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:37559 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbZIUQpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:45:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bYz++Gul4zBDSuVPPC9bKdZsOCTEFKl1/F6t0vAP3xWBDg95DO7hEVFg3CzCo1aR8L
         jgnh5yqmbW+g7MPB3MeOyfuGtIOOJ2LdEadyAZzmAdpN5oijV1fTiEIeQdK6dmuD4oUz
         6W5rvLjpedxf4R27nIvreEve06YH1ZZT/j8jI=
MIME-Version: 1.0
In-Reply-To: <20090916050236.GF2756@core.coreip.homeip.net>
References: <20090915062050.GB10232@core.coreip.homeip.net> 
	<1253062178-18196-1-git-send-email-vapier@gentoo.org> <20090916050236.GF2756@core.coreip.homeip.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 21 Sep 2009 12:45:02 -0400
Message-ID: <8bd0f97a0909210945s5e3d9613pa7a72271ec6b47bc@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v2] input/keyboard: add ADP5588 
	QWERTY I2C Keyboard Input device driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 01:02, Dmitry Torokhov wrote:
> On Tue, Sep 15, 2009 at 08:49:38PM -0400, Mike Frysinger wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
>> ---
>> v2
>>       - merge my and Dmitry's clean up fixes
>>
>
> Looks good, I'd also like to add this instead of recalcularing delay
> every time:

this should continue to work fine with cpu scaling right ?
-mike
