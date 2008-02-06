Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbYBFU3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbYBFU3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbYBFU3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:29:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:6062 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbYBFU3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:29:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=IcsUX2+XMaOo/jy0LxZMgWTxbDSpXZVX6u8PI553X/MjUgVyqy9DDJsP61japun6/DN2te7uHumFJXDijN4STkFvoP3KuiL7KshkVZE8RXf+B3BpbLfMCHO/C2irlyzQXN1lKCj+NE/qrwZ5/oQu1tuxKa0v6aSkdL+OQZKLEhI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 2/5] ide: remove redundant BUG_ON() from [atapi_]reset_pollfunc()
Date: Wed, 6 Feb 2008 21:43:18 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200802020146.30385.bzolnier@gmail.com> <47A9F78D.20904@ru.mvista.com>
In-Reply-To: <47A9F78D.20904@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802062143.19121.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2008, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> > Same BUG_ON() is present inside ide_set_handler().
> 
>     There is no BUG_ON there -- __ide_set_handler() has a check for the same 
> condition and a printk(KERN_CRIT)... myabe it should be replaced with BUG_ON()...

Yeah, you're right - care to make a patch?

> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> MBR, Sergei
