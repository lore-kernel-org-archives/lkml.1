Return-Path: <linux-kernel-owner+w=401wt.eu-S933616AbZLOU0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616AbZLOU0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933599AbZLOU0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:26:20 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:40079 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119AbZLOU0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:26:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xQMxNJtHshh/9OsPStDTU45fAuLPyH1/Ops6R8u2CADavMMdz/XkP2gvYKH4NynNuN
         bHqrpc5H1qIWaCY/bn9ctdtm7DRMYyCP0QYzY/xmVux2UBs2bfFixXSQQL4dPvL4MJxI
         zuVwYd4Yc2QcuTF1OXL+2CZPG/S8d9jldc3tc=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0912132013050.26173@ayla.of.borg>
References: <alpine.DEB.2.00.0912132013050.26173@ayla.of.borg>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 15 Dec 2009 15:25:50 -0500
Message-ID: <8bd0f97a0912151225j12d29d23x4383b0ddf00f0012@mail.gmail.com>
Subject: Re: [PATCH] Keys: KEYCTL_SESSION_TO_PARENT needs TIF_NOTIFY_RESUME 
	architecture support
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       "Linux/m68k" <linux-m68k@vger.kernel.org>,
       Chris Zankel <chris@zankel.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 14:21, Geert Uytterhoeven wrote:
> +       /*
> +        * To be removed when TIF_NOTIFY_RESUME has been implemented on
> +        * blackfin/m68k/xtensa

if you feel like respinning, you can drop the "blackfin" part as ive
pushed support for 2.6.33
-mike
