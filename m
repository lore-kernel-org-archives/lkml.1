Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZKKMMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZKKMMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 07:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbZKKMMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 07:12:52 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:41822 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382AbZKKMMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 07:12:51 -0500
MIME-Version: 1.0
In-Reply-To: <4AFA835B.9000904@garzik.org>
References: <bd36f99e0911110118v6dc7f87ao98968ba234fad7fc@mail.gmail.com>
	 <4AFA835B.9000904@garzik.org>
Date: Wed, 11 Nov 2009 07:12:57 -0500
Message-ID: <bd36f99e0911110412hf2c7920gf06bd29ed43e240c@mail.gmail.com>
Subject: Re: Crash during SATA reads
From: Glenn Maynard <glenn@zewt.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/11 Jeff Garzik <jeff@garzik.org>:
> Looks like it is dying somewhere in the block layer, maybe the
> bh->b_end_io() pointer is NULL.
>
> Does the attached patch trigger the added BUG_ON() statement?

I had that thought, too, but that change seems to have masked the
problem; I'm having trouble reproducing it at all.

-- 
Glenn Maynard
