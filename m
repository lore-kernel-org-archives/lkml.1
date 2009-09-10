Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZIJJYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZIJJYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 05:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZIJJYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 05:24:47 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:49486 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbZIJJYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 05:24:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=MTfaHq3k75ShchTxBs9ToSqhPFiCELw6yfAQcXLMRiPk1UPyXempXyjouhxiaSlfTR
         n2zXdLOXuHiqQnmvBEyEsFS9qz2dOUqiBU3NAfYDP8wP9CVNz20ryD+uSz2gCUEYfJIU
         DDDZ8COQdhe7qLtevvm6mXZ4TcKKuZ8F/isPU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Nvidia IDE MCP78S not syncing: Fatal exception in interrupt
Date: Thu, 10 Sep 2009 11:25:27 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-00015-gadda766-dirty; KDE/4.3.0; i686; ; )
Cc: Stevan Silva <tevost@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <d6592cfc0909061317k2dd1989did35ec4d1d68e80f9@mail.gmail.com> <20090909221234.daea7525.akpm@linux-foundation.org>
In-Reply-To: <20090909221234.daea7525.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909101125.27653.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 September 2009 07:12:34 Andrew Morton wrote:
> (cc linux-ide)
> 
> null-pointer deref in ide_complete_rq().
> 
> On Sun, 6 Sep 2009 17:17:08 -0300 Stevan Silva <tevost@gmail.com> wrote:
> 
> > I recently bought an ASUS M4N78 PRO motherboard, that is based in the
> > nvidia's geforce 8300 chipset and updated my system kernel to 2.6.30
> > version.

We're at 2.6.30.6 / 2.6.31 now so it would be worth to try them first
(I remember similar problem being fixed some time ago).
