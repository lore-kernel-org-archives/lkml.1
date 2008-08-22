Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbYHVNok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbYHVNok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 09:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbYHVNob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 09:44:31 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:59939 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYHVNoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 09:44:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GQ/IEPCI1uCtVfQDfsJs0J80nJ/cnvAaPJw2V1/l9tGRL/nNkGPSYZOwF+q/1tXWkr
         I+QctGHvMIq5X2+ZDOYjsm60ht5csJBWY9552NJhuqDRPQeMOT8KqQpXpC4o5oCHYPmA
         z9hq1MzN7EAv5PsiA0cwZaftmuHW6W89HmkEo=
Message-ID: <8bd0f97a0808220644v67f0e51ek4500d96f09a377f4@mail.gmail.com>
Date: Fri, 22 Aug 2008 21:44:28 +0800
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney@kernel.org>
Subject: Re: [PATCH] blackfin/sram: use 'unsigned long' for irqflags
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>, "Julia Lawall" <julia@diku.dk>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080806105836.GA2903@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080806105836.GA2903@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 6:58 PM, Vegard Nossum wrote:
> From 3ef36948a88a968eec1b09859aa251dc6727df4e Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Wed, 6 Aug 2008 12:00:23 +0200
> Subject: [PATCH] blackfin/sram: use 'unsigned long' for irqflags
>
> Using just 'unsigned' will make flags an unsigned int. While this is
> arguably not an error on blackfin where sizeof(int) == sizeof(long),
> the patch is still justified on the grounds of principle.
>
> The patch was generated using the Coccinelle semantic patch framework.
>
> Cc: Julia Lawall <julia@diku.dk>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

make sure to grab this Bryan ?
-mike
