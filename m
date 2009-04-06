Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbZDFVNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbZDFVNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758758AbZDFVLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:11:49 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55424 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbZDFVLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=xAYrsH0kav3/DMr1OEYIWuTOdt0aAWL89mnxuHm0YzH7qufYdRqxlFe7Pvo1kF4u4V
         wMjgfnIDyYPzlWZkyxpq6aR3bBLU1T2EIslLHNUr71g4rSFNZDVgWFhM41gRH5RAkqs/
         F0DcpFLjaeNwCP712L0c+rMk0w4EvJbMfYaZI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] tx493[89]ide: Remove big endian version of tx493[89]ide_tf_{load,read}
Date: Mon, 6 Apr 2009 23:13:50 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1239034146-3514-1-git-send-email-anemo@mba.ocn.ne.jp> <49DA2C50.6000108@ru.mvista.com>
In-Reply-To: <49DA2C50.6000108@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904062313.50980.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 April 2009, Sergei Shtylyov wrote:
> Atsushi Nemoto wrote:
> 
> > Now tx493[89]ide_tf_{load,read} do not contain word I/O operations.
> > They are endian-free now.
> 
> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> 
>     Oops, now this clashes with my patchset (not applied to pata-2.6 AFAICS). 
> I guess I'll have to repost it... Bart?

Since I already had your patches merged locally I just applied this one
in front of yours and then repeated:

- force apply the patch
- ignore rejects
- refresh the patch
- audit the result

cycle for all patches.

It seems like the end result is OK (changes to big endian ->tf_{load,read}
vanished, change to "fixup" ->tf_load survived and all patch descriptions
remained valid) but please verify it.

Thanks,
Bart
