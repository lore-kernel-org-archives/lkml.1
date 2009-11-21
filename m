Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbZKUSmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbZKUSmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 13:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbZKUSmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 13:42:46 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:61344 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbZKUSmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 13:42:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=wAej8qaXywM+IqJwvUYnbJVYHq8ofhzEBzpAVjJDcnjuEHhorLlw6m/FYGUMFM7lY7
         N1ClBDcd5IJ+9/Clzui8by5iEs4+/1OaBYV5zEuQjdcuTyPXBebLi7hUmHEyTsUSvdS+
         xzv27DPNyLMcNGJDsg5suCaVi3PV0dA1N1qyk=
MIME-Version: 1.0
In-Reply-To: <4B08330E.4020300@gmail.com>
References: <4B08330E.4020300@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 21 Nov 2009 13:42:32 -0500
Message-ID: <8bd0f97a0911211042t20d0df24w191b30c724b102d3@mail.gmail.com>
Subject: Re: [PATCH] Blackfin: Fix memset in smp_send_reschedule() and -stop()
To: Roel Kluin <roel.kluin@gmail.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 13:35, Roel Kluin wrote:
> To set zeroes the sizeof the struct should be used rather
> than sizeof the pointer, kzalloc does that.

thanks, ive merged this
-mike
