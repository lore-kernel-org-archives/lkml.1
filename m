Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbXFLUKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbXFLUKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 16:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXFLUKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 16:10:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:29725 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812AbXFLUKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 16:10:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D55vV7R1R0NpyH6B/rvVfpxCVC6ahVAvCx9dgQSUCnWpVBomR9pXVb3pjz9InPa8Pf2q7BvryqPs6CmZ8f4fUap75pwZnA8v6YY0GEHYnnZiotj9z20Xd9IT8YNGialp82zT7PV1P0LydJhcLttEWeYXckUM0trpsgZqwORtKlI=
Message-ID: <d120d5000706121310o51086d38nd05916448b6f7403@mail.gmail.com>
Date: Tue, 12 Jun 2007 16:10:08 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Paul Albrecht" <albrecht@rdi1.com>
Subject: Re: [BUG] via c3/2.6.20 -- ps/2 keyboard doesn't work with console
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1181674936.2533.1.camel@albrecht.rdi1.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181236651.15435.1.camel@albrecht.rdi1.com>
	 <d120d5000706111228g4ada3a8dxf8e31dc62cfab476@mail.gmail.com>
	 <1181588095.2436.5.camel@albrecht.rdi1.com>
	 <200706120114.48645.dtor@insightbb.com>
	 <1181656946.3176.1.camel@albrecht.rdi1.com>
	 <d120d5000706121150p56a581d3je6d9a886529b591@mail.gmail.com>
	 <1181674936.2533.1.camel@albrecht.rdi1.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Paul Albrecht <albrecht@rdi1.com> wrote:
>
> There must be some difference between the sources we're using because
> when I try to patch 2.6.21.5 I get this for output:
>
> patch --dry-run -p1 < ../i8042-trust-pnp-more.patch
> patching file drivers/input/serio/i8042-x86ia64io.h
> Hunk #1 succeeded at 313 (offset -43 lines).
>

Yes, I have bunch of changes in my tee that have not hit the mainline
yet. The patch wasn't actually gererated off 2.6.21.5; I just verified
that it spplies to it.

> However, the patch succeeded so I retested without i8042.noaux and that
> worked. Here's the dmesg output:

Ok, great! Now let's see if I can get some more testers to try it to
make sure there are no regressions on other people's boxes.

-- 
Dmitry
