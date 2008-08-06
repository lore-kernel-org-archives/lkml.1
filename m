Return-Path: <linux-kernel-owner+w=401wt.eu-S1762109AbYHFLGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762109AbYHFLGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 07:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbYHFLGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 07:06:00 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:28524 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbYHFLF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 07:05:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TqykhvS560fnHL7KRiqplWXvoe4k95x3JhTcAOdcLUBz0qf/XqeqevN0XRgpFLnS95
         kTPY2zNrrrBkcVBS8yZxsY1/hp7EzPSxiMsWgpV+27iVQ/p5/eJHzWgEsM2RM94QRgU4
         evSnUgbbgwa+lzmnKmu3xJ1y1yXh5AehADl98=
Message-ID: <8bd0f97a0808060405qf70ead2t2f2604802875197e@mail.gmail.com>
Date: Wed, 6 Aug 2008 07:05:57 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [PATCH] blackfin/sram: use 'unsigned long' for irqflags
Cc: "Bryan Wu" <cooloney@kernel.org>, "Julia Lawall" <julia@diku.dk>,
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

On Wed, Aug 6, 2008 at 6:58 AM, Vegard Nossum wrote:
> From 3ef36948a88a968eec1b09859aa251dc6727df4e Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Wed, 6 Aug 2008 12:00:23 +0200
> Subject: [PATCH] blackfin/sram: use 'unsigned long' for irqflags
>
> Using just 'unsigned' will make flags an unsigned int. While this is
> arguably not an error on blackfin where sizeof(int) == sizeof(long),
> the patch is still justified on the grounds of principle.

indeed, thanks

> The patch was generated using the Coccinelle semantic patch framework.

spam ?

> Cc: Julia Lawall <julia@diku.dk>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

should be CC Bryan Wu as well ...
-mike
