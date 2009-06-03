Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZFCJrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZFCJrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZFCJrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:47:36 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:26840 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZFCJrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vf9IWyCSnTTWHFRO+PqNDhIFz+hOsNzJXR4b3WUs8Dtd3YdneHoVaQoP0YHH3fyey5
         92Ja051yHtWUuFQJUg3YfCvo5TWOtAE3a0lHrsx4/x+a9vjGM9GGUCS8ktqEEPFfqlbX
         wGpFJHgSHbwI3OhKAAYE9BzGmUtbAtuM32RWc=
MIME-Version: 1.0
In-Reply-To: <20090603095346.64c874b1@lxorguk.ukuu.org.uk>
References: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
	 <1243926700-30485-4-git-send-email-vapier@gentoo.org>
	 <20090602100018.415b1dfc@lxorguk.ukuu.org.uk>
	 <8bd0f97a0906030103i64bc1a9duc5aeaea7bd3f8365@mail.gmail.com>
	 <20090603095346.64c874b1@lxorguk.ukuu.org.uk>
Date: Wed, 3 Jun 2009 05:47:36 -0400
Message-ID: <8bd0f97a0906030247ueeb9320k30e794109ca51758@mail.gmail.com>
Subject: Re: [PATCH 04/11] Blackfin SPORT UART: fix overrun errors
From: Mike Frysinger <vapier.adi@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 04:53, Alan Cox wrote:
>> > This should have no effect on a modern kernel.
>>
>> well, we wouldnt be making changes if we werent seeing data overruns today
>
> If it has an effect then something else is going on.
>>
>> > There is 64K of queueing between you and the ldisc nowdays.
>>
>> i dont think that really matters ... we do too much work in the
>> interrupt and so we miss new data
>
> Which the other patches addressed so my guess is the real fixes were the
> other changes.

pfft, always got to make us do real work :)

since the serial stuff is in a bit of orphaned state (going by
MAINTAINERS), should i merge the other changes through the Blackfin
tree ?
-mike
