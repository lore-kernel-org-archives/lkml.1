Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbXEVA3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbXEVA3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbXEVA3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:29:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:34653 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbXEVA3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QvlJGCg3ocoM3XDDtacIuCqF5D5eXWHb4LNwr/NXlnLNQO4Rf5aetPh+PzDNoUFHf0PnNb1gVYh0o6NW9LFsDKE53BMhnEUBlmBUpopDZhm9QRsjWXXJY/up05lfvF1hBB641vgCGf8OYbLVQCB8KmLWnjjumBn2oDSTQZ6iODE=
Message-ID: <2c0942db0705211729r185d7d77r2750d82f4a3b3e9c@mail.gmail.com>
Date: Mon, 21 May 2007 17:29:40 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/5] 2.6.22-rc2: known regressions
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Adrian McMenamin" <adrian@newgolddream.dyndns.info>,
       linux-acpi@vger.kernel.org, "Len Brown" <lenb@kernel.org>
In-Reply-To: <464F74BB.9070402@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F74BB.9070402@googlemail.com>
X-Google-Sender-Auth: b5c74fb3e3356055
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey there,

On 5/19/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Here is a list of some known regressions in 2.6.22-rc2.
>
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
>
> Subject    : nx6125 has lost fan control
> References : http://lkml.org/lkml/2007/5/16/249
> Submitter  : Ray Lee <ray-lk@madrabbit.org>
> Status     : Unknown

I'm withdrawing this one. At boot, it wasn't controlling the fans, but
after a suspend-resume it started up fine. My subsequent boots have
also been okay, so I'm at a loss to explain what I saw.

Regardless, given that it's hard to reproduce, I have no evidence that
it's a regression, it could just be something that's really rare.

Thanks,

Ray
