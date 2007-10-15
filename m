Return-Path: <linux-kernel-owner+w=401wt.eu-S1762081AbXJOJrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762081AbXJOJrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbXJOJrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:47:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:42702 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527AbXJOJrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YXxPNuRN25ODYbDaB2B6XxPrWne6eR/2BnUoXKZuBiEqdOCavLHeEJHoT5wPn30+CBwBiQYJfcBJUYKT6ckISptjIw6W8//N0AAt6Ka78fBRPLc4n4tSpZoJ363rSrMOCb+y1DdCqxzKDsijRyeZ+b5FIV+gdWTyNtKC8gRgzfM=
Message-ID: <68676e00710150247s23d06db2sdb17af6fafdc4b77@mail.gmail.com>
Date: Mon, 15 Oct 2007 11:47:20 +0200
From: Luca <kronos.it@gmail.com>
To: "Don Mullis" <dwm@meer.net>
Subject: Re: Hitachi disk: spurious completions during NCQ
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <87zlyksyfc.fsf@meer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9cP6K-6rV-29@gated-at.bofh.it> <87zlyksyfc.fsf@meer.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/07, Don Mullis <dwm@meer.net> wrote:
>
> > ata3.00: spurious completions during NCQ issue=0x0 SAct=0x407fd FIS=005040a1:00020000
> > ata3.00: cmd 61/08:00:c7:5a:82/00:00:1b:00:00/40 tag 0 cdb 0x0 data 4096 out
> >          res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)
>
>
> This has been seen with several Hitachi drives.  There's speculation
> that it's due to a bug in the drive firmware:

Yes, I'm aware of this. That's why I was suggesting to blacklist this drive.

thanks,
Luca
