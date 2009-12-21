Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZLUS62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZLUS62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 13:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbZLUS60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 13:58:26 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:35297 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZLUS6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 13:58:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=u4jaZ0GOVSCVUn+xenNo5lNNsUOSeudrrQcuJwYgXBPQ3DqCJ21Y/LESwy4/RTEJHo
         qtJ6WqVxP1hh9Rhx3uZ7MtVLmr9TJLyPYMBMoAGWsZeH1sXV5u+6inUnHmKp+qa64h1u
         CzTdUJJoELPPbduI+mUZZI3GCdD53Ggk9MtcE=
Message-ID: <4B2FC54D.1070000@garzik.org>
Date: Mon, 21 Dec 2009 13:58:21 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] libata: pata_bf54x: handle portmuxing of pins through
 	GPIO PORTs
References: <1247593187-26570-1-git-send-email-vapier@gentoo.org> 	<4A5CD77C.6070701@garzik.org> <8bd0f97a0912210621g19535a03q38b8b67c01df6a75@mail.gmail.com>
In-Reply-To: <8bd0f97a0912210621g19535a03q38b8b67c01df6a75@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 09:21 AM, Mike Frysinger wrote:
> On Tue, Jul 14, 2009 at 14:07, Jeff Garzik wrote:
>> Mike Frysinger wrote:
>>> By default, the PATA pins are routed to the async address lines in which
>>> case, no peripheral muxing needs to be done.  However, if the pins get
>>> routed through the GPIO PORTs pins, we need to make sure to request them
>>> so that the muxing is properly set up.
>>> ---
>>> Andrew: could you pick this up ?  it was posted over a month ago to the
>>> Linux/IDE list w/no feedback.
>>
>> Although it is disappointing that your patch was missed -- our apologies --
>> I don't think the best response was to elide linux-ide and the libata
>> maintainer, in favor of a higher noise list.  :)
>>
>> I have the patch queued, now.
>
> so it's been 8 months since it was posted, 6 months since it was
> queued, and multiple libata merges have been made, but this patch has
> yet to make it into mainline ...

No idea how it got lost :(   Just sent a pull request to Linus with this 
in it.

	Jeff




