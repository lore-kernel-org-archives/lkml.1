Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbYKNTzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbYKNTzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYKNTz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:55:29 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:48639 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbYKNTz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:55:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ib2VZaDstnswVfOFXUUvLMaPMon56i6zplQmLZtqLaRbHJHyiY7LtXj8euWOHsS0Rk
         Kj+P959TI0Z0eM5hBKraaTsKQGkDZapKvYYoUjCZpYqlHkdaJoapTPqX/CjZ2snvDAP4
         TbRoyWjBW/TAbz8+TYIVBogwsE2qvu7/wpIWw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Strange behavior since commit 5fef0e5c
Date: Fri, 14 Nov 2008 20:53:05 +0100
User-Agent: KMail/1.9.10
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       LKML <linux-kernel@vger.kernel.org>, linux-pcmcia@lists.infradead.org
References: <491D92EB.2030200@lwfinger.net>
In-Reply-To: <491D92EB.2030200@lwfinger.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811142053.05880.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2008, Larry Finger wrote:
> In testing kernel version 2.6.28-rc4 on my server that was running kernel
> 2.6.27, an external IDE disk system connected via a PCCard interface failed to
> start because module ide_disk would not load. The console output is as follows:
> 
> finger@sonylap:~> sudo modprobe -v ide-disk
> WARNING: module 'ide_gd_mod' is unsupported
> FATAL: Module ide_disk not found.

Please verify that your system uses a recent module-init-tools version
and then repeat 'make modules' + 'make modules_install' (it could be that
something went wrong previously during installing modules) as it works
just fine for me with 2.6.28-rc3 and module-init-tools 3.4.

Thanks,
Bart
