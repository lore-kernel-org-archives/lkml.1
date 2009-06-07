Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZFGNpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZFGNpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbZFGNo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:44:58 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:55405 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZFGNoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:44:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=uw+UPdrEp0NogOcL73+sjyhbqBARxYCkSREzPQuSwPKuSuRVz+hZHzURD7AzZlrObx
         fq0DotXBkLLv4zk65TrZWGtissZe8/t5nh9uvgFcnhOfPuYu5jqmcGKXfV2ZXrThZsEQ
         /W4i45r54T+vk1HCexMHiPl1dX0Q5IjrlWJ90=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 0/2] ide-tape: fix flags
Date: Sun, 7 Jun 2009 15:04:13 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
References: <1243926308-32385-1-git-send-email-petkovbb@gmail.com> <200906052034.06668.bzolnier@gmail.com> <20090606175836.GA12865@liondog.tnic>
In-Reply-To: <20090606175836.GA12865@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906071504.13725.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added Jiri to cc: ]

On Saturday 06 June 2009 19:58:36 Borislav Petkov wrote:
> On Fri, Jun 05, 2009 at 08:34:06PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday 02 June 2009 09:05:06 Borislav Petkov wrote:
> > > Hi Bart,
> > > 
> > > those fix a stupid flags misuse that got spotted by Jiri Slaby. Please
> > > pay special attention to the first patch. FWIW, those can go as hot
> > > fixes right away and we might catch 30-rc8 since it's not out yet.
> > 
> > The problem is that patches seem to be against ide-2.6.git/for-next...
> 
> Sh*t, this is hitting the broken buffer allocation that Tejun removed
> (I'm getting the same OOM-kill as the one Tejun's mentioning here
> http://marc.info/?l=linux-ide&m=124191711928890) so even with those
> patches, ide-tape is still broken.
> 
> I'm guessing backport all of Tejun's ide-tape cleanup stuff after Linus
> pulls them into 31-rc1?

Seems so, though it may be too much work for too little gain
(we still have other open ide-tape issues like DMA related one).

In the meantime I applied your patches to for-next..
