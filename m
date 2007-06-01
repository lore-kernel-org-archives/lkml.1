Return-Path: <linux-kernel-owner+w=401wt.eu-S1763444AbXFASij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763444AbXFASij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762922AbXFASic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:38:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:62292 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761282AbXFASib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:38:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=f10qxn4fMJlItGgezgfHu5xpyzUG81fiFPs6DmK0IGUzrmJ+SNhRL4I2n1SPjHsZCWDE3e+vew8GwEDmFxUbCWpngbPsRy1HV3g66xS676jr4jp8uptNa55v2djSAg3Ln0vskOksZP6AUKf09Hk+pcU3GnccDftcD7Mc5zYlCjo=
Message-ID: <75b66ecd0706011138v25e0d352p2fe5c4b5b8933046@mail.gmail.com>
Date: Fri, 1 Jun 2007 14:38:30 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Matthew Fredrickson" <creslin@digium.com>
Subject: Re: Device Driver Etiquette
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <a714c0e137cf5cf814e790e3fdef23c8@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a714c0e137cf5cf814e790e3fdef23c8@digium.com>
X-Google-Sender-Auth: 203f636b8aed7603
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/07, Matthew Fredrickson <creslin@digium.com> wrote:
> is it acceptable (although
> not nice) to simply fix it this way, by disabling irqs while it loads
> the firmware?
>

I would say to just disable IRQs while loading firmware.  Almost every
server I maintain has some vendor driver which generates a "many lost
ticks!" message on load.  As long as it's only done at module load
time it should be fine.

Of course the best solution is to just get the driver into mainline.

Lee
