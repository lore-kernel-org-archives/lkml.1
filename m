Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbZBSAYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbZBSAYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZBSAYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:24:31 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:54145 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZBSAYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:24:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d7dSvNeBgpAN/vnThttZHUFewJRdl6BKg2u0eRVWrkJZiQyxpnxv+8AigEp0key6pn
         2gwgm9WcaG7Bp2dxxM+E6YSJkA2bSMtNr5oUd1yLnsSHaoYSruJaiDgi5TQnll63ONVk
         hhCCXgtbdV/QGMId5uDuzp9m8YpiswzV+zDOo=
MIME-Version: 1.0
In-Reply-To: <1234972402-24298-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1234972402-24298-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
	 <1234972402-24298-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
Date: Wed, 18 Feb 2009 16:24:29 -0800
Message-ID: <6934efce0902181624q57f3423dm50cda218781e4399@mail.gmail.com>
Subject: Re: [PATCH 5/5] squashfs: Make SquashFS 4 use the new pcomp crypto 
	interface
From: Jared Hulbert <jaredeh@gmail.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Modify SquashFS 4 to use the new "pcomp" crypto interface for decompression,
> instead of calling the underlying zlib library directly. This simplifies e.g.
> the addition of support for hardware decompression and different decompression
> algorithms.


Geert,

When did this become an option?  I thought zlib in the crypto
interface was not compatible with zlib.  Is that not the case anymore?
 Have you looked at AXFS enough to judge if this would be as easy a
job as it looks to convert?


How do you get from here to supporting alternate compressors?
