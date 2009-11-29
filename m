Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbZK2DEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbZK2DEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 22:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZK2DEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 22:04:24 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:46620 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbZK2DEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 22:04:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=dXgm5VbdNtTbaMcwjjtUpdosXfto2apnDZkXLuczFEDn6I6yK+QybrHNX2gpVSQKM4
         CkTecVXszDpXR1cOKSIVmCMZmtOS1qZsuRNglOsi614br0cEXAWlVL9dbWTJTY8HJCjo
         cHmx2H0rKrqygQwSuuN7nQQgR6KxR4BK0HFyw=
MIME-Version: 1.0
In-Reply-To: <1259051133-7911-1-git-send-email-mike@compulab.co.il>
References: <1259051133-7911-1-git-send-email-mike@compulab.co.il>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sun, 29 Nov 2009 11:04:08 +0800
Message-ID: <f17812d70911281904j2811c55x5e58d0a49565df76@mail.gmail.com>
Subject: Re: [PATCH] backlight: tdo24m: ensure chip select changes between 
	transfers
To: Mike Rapoport <mike@compulab.co.il>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 4:25 PM, Mike Rapoport <mike@compulab.co.il> wrote:
> Some SPI host drivers do not change chip select betwen transfers unless
> .cs_chnage field is explicitly set. The LCD spec requires chip select
> change between consecuitive transfers, so ensure it at the SPI driver
> level.
>
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>

Applied to 'devel'.

Richard,

I'd still hope this can be merged via your backlight tree, and let me know
when that's done so that I can drop this here.
