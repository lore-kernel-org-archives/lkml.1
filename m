Return-Path: <linux-kernel-owner+w=401wt.eu-S1761106AbZE0LiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761106AbZE0LiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758111AbZE0Lhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:37:55 -0400
Received: from mail-px0-f191.google.com ([209.85.216.191]:35728 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158AbZE0Lhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=EH4sG0kY3kjSc947v0vOB+TL/n8SoJgVB66ZlqpyKdU7ZXomf+1crC6zIzNdvTMXnX
         O3DJMJPAVbZ2y/lzf5VKxGKfULzuJ1GGbp7YvwOVOViNJCy3KGJS+h9glK3yV4dplKyb
         yHQ/rGFNfDAT97G6D/cI35EMuo5Vekr1U7a3E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3] ide: add "ignore_hpa" module parameter
Date: Wed, 27 May 2009 13:41:52 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: Frans Pop <elendil@planet.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200905252344.11826.bzolnier@gmail.com> <200905261915.47212.bzolnier@gmail.com> <20090527113857.2a30e9d7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090527113857.2a30e9d7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905271341.52268.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 May 2009 12:38:57 Alan Cox wrote:
> > All information was there (kernel logs).
> > 
> > Moreover the default in libata is to not remove HPA settings.
> > 
> > I don't recommend parsing kernels logs in search of such information but
> > you're are stretching the reality too far to match with your arguments.
> 
> So you disagree that sysfs is needed and propose an alternative that you
> say you don't recommend (and which doesn't solve the block problem).

This is not what I said (if this is a straw man attempt, please don't do it).

> I used to work for a distro, and telling Bill Nottingham that the
> reliable long term way for Fedora to obtain some interface data was by
> grepping dmesg wouldn't have gone down well.

Knowing the severity of accidentally removing data from HPA (which you
described yourself in the other mail) and also not being able to access
valid data from HPA (bug #13365) I would simply use in the installer
the alternative [*] (that I *don't* recommend as the long-term solution)
and then start working on adding proper sysyfs kernel interfaces (that
I *don't* consider not needed) and proper installer support.

[*] it would of course require passing "libata.ignore_hpa=1" to kernel
    during installation time

This would result in much less hassle for users, much less support costs
for distribution and having proper in-kernel / installer support faster
than doing it the non-pragmatic way (since we would save a lot of time on
handling bug-reports and discussions like this one).
