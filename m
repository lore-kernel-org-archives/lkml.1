Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbZELLwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbZELLwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbZELLv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:51:58 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:39881 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZELLv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:51:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ikdWvaKAyD7r+7MGrB8s6116zRxUV4vTsihrkmRMcK9gZ/NmsyZBxArwkwb92yulYp
         Dh3M4x18UdN8hV5jGpqNfKKhl7xK3iL4cHeyhB3x3FmmdbXOFL65tOPkUVCt+/DilQZy
         z7FqL+Trwj2dcclHkGZA3XbJ2ZXndsRyD5ohc=
MIME-Version: 1.0
In-Reply-To: <1242127393-4298-1-git-send-email-a.beregalov@gmail.com>
References: <1242127393-4298-1-git-send-email-a.beregalov@gmail.com>
Date: Tue, 12 May 2009 15:51:56 +0400
Message-ID: <a4423d670905120451p5cd8b194yf3fd5572f92f083b@mail.gmail.com>
Subject: Re: [PATCH] Staging: agnx: switch config_interface to 
	bss_info_changed
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: johannes@sipsolutions.net, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Alexander Beregalov <a.beregalov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/12 Alexander Beregalov <a.beregalov@gmail.com>:
> Fix this build error:
> drivers/staging/agnx/pci.c: In function 'agnx_config_interface':
> drivers/staging/agnx/pci.c:315: error: dereferencing pointer to incomplete type
> ..
> drivers/staging/agnx/pci.c:424: error: unknown field 'config_interface' specified in initializer
>
> config_interface was removed in 2d0ddec5b2b
> ("mac80211: unify config_interface and bss_info_changed")
>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---

stlc45xx has the same problem (drivers/staging/stlc45xx/stlc45xx.c:2360)
It is not so simple, I do not know how to fix it.
