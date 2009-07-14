Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbZGNXCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbZGNXCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 19:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbZGNXCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 19:02:12 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:61408 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620AbZGNXCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 19:02:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=aMl3ajgnOwCdyGOD8J5XjqVqiUUiTstoCJGCIGlieDytNZPCcZdvxPgo9lbLJv9hNF
         OLLlM6yQZA8+NlGRnv3gAbKd370yYmbupHAUKC1rslYlT5/vw+CBZ0mAuG4dScx/CasM
         kdfQ4j5lL8Agqtzy+0iCmFMhJUIEYbuYEh8vo=
MIME-Version: 1.0
In-Reply-To: <4A5CD77C.6070701@garzik.org>
References: <1247593187-26570-1-git-send-email-vapier@gentoo.org> 
	<4A5CD77C.6070701@garzik.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 14 Jul 2009 19:01:50 -0400
Message-ID: <8bd0f97a0907141601v64bb911ci4234ce845b48de50@mail.gmail.com>
Subject: Re: [PATCH] libata: pata_bf54x: handle portmuxing of pins through 
	GPIO PORTs
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 15:07, Jeff Garzik wrote:
> Mike Frysinger wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> By default, the PATA pins are routed to the async address lines in which
>> case, no peripheral muxing needs to be done.  However, if the pins get
>> routed through the GPIO PORTs pins, we need to make sure to request them
>> so that the muxing is properly set up.
>>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> ---
>> Andrew: could you pick this up ?  it was posted over a month ago to the
>> Linux/IDE list w/no feedback.
>
> Although it is disappointing that your patch was missed -- our apologies --
> I don't think the best response was to elide linux-ide and the libata
> maintainer, in favor of a higher noise list.  :)

the assumption was that linux-ide was dead rather than missed as is
the cases with some sections and Andrew can pick up simple things.
i'll make sure to send to you in the future as well.

> I have the patch queued, now.

thanks
-miek
