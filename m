Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZEZRLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZEZRLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZEZRLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:11:42 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:42750 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbZEZRLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:11:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=bDTBrsOVh8YwNImG0NFqfOquhFxG2Hvc3OsdmKKDVhfsWKlyoepL12iLrK8dJ2FawD
         EXIaJj0xowQNyvjVC4O9MkuGihZA7o7Eh3b3Ya7bch4M2tWdBCKkd9EqRiFXa5ddSUT0
         5I1Zb6rdCsgCFla1VQOMZhNjTdciiAXpVGiG0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3] ide: add "ignore_hpa" module parameter
Date: Tue, 26 May 2009 19:15:46 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: Frans Pop <elendil@planet.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200905252344.11826.bzolnier@gmail.com> <200905261423.40117.bzolnier@gmail.com> <20090526135343.5bcaa92b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090526135343.5bcaa92b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905261915.47212.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009 14:53:43 Alan Cox wrote:
> > Please note that no fancy sysfs support was needed to prevent the problem:
> > both stacks (ide & libata) support HDIO_DRIVE_TASK ioctl which can be used
> > to execute commands needed to retrieve/change HPA setting.
> 
> Wrong. You need sysfs support because you may not be able to retrieve the
> HPA settings after the drive has removed them. You also need a trigger of

All information was there (kernel logs).

Moreover the default in libata is to not remove HPA settings.

I don't recommend parsing kernels logs in search of such information but
you're are stretching the reality too far to match with your arguments.
