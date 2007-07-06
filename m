Return-Path: <linux-kernel-owner+w=401wt.eu-S1762135AbXGFKJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762135AbXGFKJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbXGFKJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:09:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:13267 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbXGFKJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:09:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HTEvo+FJRYbxy8jGhjnroF1cK3mVmB003ZUyY9+kdoqAFQq1Qr0oyrgI4U/+GMwQ47edshffUOh4pfzw17Y6+StNKoJdKwz9bnU818AyVMBF0Veva269xWIf7c4H9bByHe0wGjD4x+AdxRasOQ04VeKC4mdwNvC7na3y42LewmM=
Message-ID: <92a12cdb0707060309x6fe997nc3112d5545d73ef5@mail.gmail.com>
Date: Fri, 6 Jul 2007 11:09:00 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [alsa-devel] [PATCH] ALSA AICA sound on SEGA Dreamcast - fix behaviour in poor resource conditions
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <s5hvecx4zz5.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0707051507r7ab1516blb7ea755d89c25efa@mail.gmail.com>
	 <s5h3b016fzx.wl%tiwai@suse.de>
	 <92a12cdb0707060246p407f19depe16c59ac43eb0d96@mail.gmail.com>
	 <s5hvecx4zz5.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/07, Takashi Iwai <tiwai@suse.de> wrote:
> I guess you shoud call del_timer() there at least.  Otherwise the
> timer handler (aica_period_elapsed()) might be called even if the
> stream is not really running.
>

Fair enough. I'll fix that and repost later.

> The below is some coding style fixes, BTW.  I'm not sure whether
> queue_work() is intended in the block if "if (dma_check == 0)" or
> not.
>

It's just an aberrant indent - I think there was an independent block
there in earlier code, it got removed but the tab stayed :)
