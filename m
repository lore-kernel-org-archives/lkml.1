Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0CHQlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:41:53 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50272 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab0CHQlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:41:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=u76LyltKRYIvqdyWCRjxKDeLq4nCxmFJVzWBeQcIZn1Xs+8zfPjImUHTXf2HHhx0jt
         YfQTar65kVV/fkmaQ5LNP2b8Fv5snflMwD+WbUX45sP1vvHHg1ngHq60LLkgeTRAGnc6
         7ZpLOVdOrmzeT73Lbw5jOeiB/FmzAVulyw5Is=
MIME-Version: 1.0
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB0321623721@dbde02.ent.ti.com>
References: <1268065561-24350-1-git-send-email-vapier@gentoo.org> 
	<5A47E75E594F054BAF48C5E4FC4B92AB0321623721@dbde02.ent.ti.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 8 Mar 2010 11:41:26 -0500
Message-ID: <8bd0f97a1003080841p7e425822w5eeb31b97cff0baf@mail.gmail.com>
Subject: Re: [PATCH] USB: musb: fix build error introduced by isoc change
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 8, 2010 at 11:31, Gadiyar, Anand wrote:
> Mike Frysinger wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> The recent commit "usb: musb: Fix for isochronous IN transfer" (f82a689fa)
>> seems to have been against an older kernel version.  It uses the old style
>> naming of variables.  Unfortunately, this breaks building for most MUSB
>> users out there since "bDesiredMode" has been renamed to "desired_mode".
>>
>
> Looks like this code is under a "#ifdef USE_MODE1" check; that's why
> we did not find this during regular builds.

ah, ok.  Felipe should tweak the changelog to mention this when merging ;)

> Felipe's upcoming patches would make this code redundant anyway.
>
> Till then, we might as well fix it.

right ... this at least should go into 2.6.33.x
-mike
