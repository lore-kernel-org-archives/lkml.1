Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbYBLANW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbYBLANW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbYBLANA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:13:00 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:44764 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803AbYBLAM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:12:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=xDQb+usdH9UDsk7tRRZLX9Iwqw+EyBQQ5ykXU6eu/P1EyM1r7MLaicgw5C7tI3rgqGL4Tv9Tde8GwrkKIJN+AgI0BwKOhKn40X0Q4UIH3gQBc1Nk6WYhFqIT/rugNoI7M5PM4Tu3ysaUNOBTZM1ZL0fTs/wV9+NXTQy28log8W0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 1/2] ide-tape: move all struct and other defs at the top
Date: Mon, 11 Feb 2008 23:12:53 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com> <200802091725.29207.bzolnier@gmail.com> <20080209194247.GE23177@gollum.tnic>
In-Reply-To: <20080209194247.GE23177@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802112312.53174.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 09 February 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> thanks for the update earlier. I'll look into blk_{get,put}_request later and
> try it on idefloppy. In the meantime, here are the patches as requested:

Thanks.

> ---
> From 0d91862fc802d6f5aa79947b2685de6c209236f2 Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Sat, 9 Feb 2008 19:48:13 +0100
> Subject: [PATCH 1/2] ide-tape: move all struct and other defs at the top
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied

> ---
>  drivers/ide/ide-tape.c |  107 ++++++++++++++++++++++++-----------------------
>  1 files changed, 55 insertions(+), 52 deletions(-)

since there is no need to move defines for tape flags around (as they are
completely rewritten by the next patch) I removed this change from this patch
making it a bit simpler/smaller:

 drivers/ide/ide-tape.c |   74 ++++++++++++++++++++++++-------------------------
 1 file changed, 37 insertions(+), 37 deletions(-)
