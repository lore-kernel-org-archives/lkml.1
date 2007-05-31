Return-Path: <linux-kernel-owner+w=401wt.eu-S1761025AbXEaURS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761025AbXEaURS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbXEaURJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:17:09 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:50833 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbXEaURH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i4ebNsLZmvMM8ZJKxR4fYDDcezlzGwa3aaMkPblnJZj4cqYt1yOnCJeKJ7DWZWZ0idtYxkDNXt92pplaYxk3tN8BCwsq4gJBYCF3fYZoNaq1bL85Ssb6RAXpluZ+NE247n1MvSM4PN+m1YIf7L9kH526eEFoOCARF8HvIQds9jg=
Message-ID: <8bd0f97a0705311317t1ed00a29w5b0d980b7e2dba6f@mail.gmail.com>
Date: Thu, 31 May 2007 15:17:05 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <bryan.wu@analog.com>
Subject: Re: [PATCH 19/20] Blackfin on-chip watchdog driver
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       "Mike Frysinger" <michael.frysinger@analog.com>,
       "Wim Van Sebroeck" <wim@iguana.be>
In-Reply-To: <8bd0f97a0705291020p5263b0bco88c556ff8cabf05c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11803414753217-git-send-email-bryan.wu@analog.com>
	 <11803414821370-git-send-email-bryan.wu@analog.com>
	 <8bd0f97a0705291020p5263b0bco88c556ff8cabf05c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/07, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On 5/28/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > From: Mike Frysinger <michael.frysinger@analog.com>
> >
> > This patch implements the driver necessary use the Analog Devices
> > Blackfin processor's on-chip watchdog controller, supports
> > BF53[123]/BF53[467]/BF561.
> >
> > Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
> > Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> > Cc: Wim Van Sebroeck <wim@iguana.be>
>
> we probably want to NACK this and wait for me to rip out the timer
> bits into a sep clockevents driver

ive updated our watchdog so it only does reset things ... should be
ready for mainline inclusion now :)
-mike
