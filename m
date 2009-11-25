Return-Path: <linux-kernel-owner+w=401wt.eu-S1759642AbZKYTy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbZKYTy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 14:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759623AbZKYTy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 14:54:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40183 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759610AbZKYTy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 14:54:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=CEenpVv/L7hlDxX9ZAGp0JHNeAwAUgo5ohMA3N9/4/UwngbyCxB6IRvuMvWkP85daA
         v11jjUY7ipYC8zgATIJbRmhzsb82kgqiSruIiB3208ugSN+66r8d93HKnjqDhgJ32BRT
         g7gWpDIjnPr3zhLISI0F3k6LUop0oLh0eH4AM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 82/86] pata_via: clear UDMA transfer mode bit for PIO and MWDMA
Date: Wed, 25 Nov 2009 20:53:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200911251910.06924.bzolnier@gmail.com> <20091125193419.2457c0ae@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125193419.2457c0ae@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911252053.09387.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 08:34:19 pm Alan Cox wrote:
> On Wed, 25 Nov 2009 19:10:06 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > On Wednesday 25 November 2009 07:06:48 pm Alan Cox wrote:
> > > > Do you really find such tidy patch hard to review?
> > > 
> > > When doing it at speed - yes.
> > 
> > Do you review everybody else patches 'at speed' or only mine?
> 
> All of them when I've got a lot of stuff to do. Owing to a lack of time
> machine and 500 hour days it's neccessary.
> 
> Also btw take it is a compliment - there are some people's patches I
> always review in detail and it isn't the patches you expect to be *right*
> that you spend the time on...

Well, you don't really have to review every single patch touching areas
that  you're just interested in (and if you're maintaining those drivers
please document it in MAINTAINERS file, thanks).

The problem is that in case you're not entirely correct, which is much
more likely when doing things 'at speed', you're will be wasting time
for everybody (not that I really care that much about  others' time but
I do care about mine).

--
Bartlomiej Zolnierkiewicz
