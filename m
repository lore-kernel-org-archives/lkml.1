Return-Path: <linux-kernel-owner+w=401wt.eu-S1759640AbZE0AHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbZE0AHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbZE0AHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:07:41 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:44540 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbZE0AHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:07:40 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 May 2009 20:07:40 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Cj3UaQlyhKc8TQC8XIim8Wo4iRZR481Drvt9+IO9CyXdel5BU0ByF5vydPsIwwPlJO
         A3rFVayZTm545xkZV+cCLIMWAq0wyWH0v1lv03L8LuWd0xxpgC7QAfRb/dL4voj9eR4j
         rO++LUuA6aXKZ7LK57it0bB3iWcxkTCoZZYtY=
MIME-Version: 1.0
In-Reply-To: <2a27d3730905220347s59dbd152kc69c8399693ae307@mail.gmail.com>
References: <2a27d3730905220347s59dbd152kc69c8399693ae307@mail.gmail.com>
Date: Tue, 26 May 2009 16:59:23 -0700
X-Google-Sender-Auth: 7c439797e76fdce4
Message-ID: <e9c3a7c20905261659v5d785df3w646efd4cbba2e6dd@mail.gmail.com>
Subject: Re: [GIT PULL] fsldma driver fixes
From: Dan Williams <dan.j.williams@intel.com>
To: Li Yang <leoli@freescale.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linuxppc-dev Development <linuxppc-dev@ozlabs.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Ira Snyder <iws@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 3:47 AM, Li Yang <leoli@freescale.com> wrote:
> Hi Dan,
>
> Here are fixes for Freescale DMA engine driver.
>
> Thanks,
> - Leo
>
>
> The following changes since commit 5805977e63a36ad56594a623f3bd2bebcb7db233:
>  Linus Torvalds (1):
>        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/drm-2.6
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/leo/fsl-soc.git fsldma
>
> Ira Snyder (4):
>      fsldma: fix "DMA halt timeout!" errors
>      fsldma: fix infinite loop on multi-descriptor DMA chain completion
>      fsldma: snooping is not enabled for last entry in descriptor chain
>      fsldma: fix memory leak on error path in fsl_dma_prep_memcpy()
>
> Li Yang (1):
>      fsldma: update mailling list address in MAINTAINERS
>
> Roel Kluin (1):
>      fsldma: fix check on potential fdev->chan[] overflow
>

Pulled, thanks.  These all look like 2.6.30 candidates, right?  I'll
send these upstream in the next few days as I have not heard back from
Kumar on taking fsldma patches through his tree [1].

Thanks,
Dan

[1]: http://marc.info/?l=linux-kernel&m=124225089507475&w=2
