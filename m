Return-Path: <linux-kernel-owner+w=401wt.eu-S933479AbZKXQgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479AbZKXQgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932214AbZKXQgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:36:15 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:44747 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123AbZKXQgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:36:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=G++1syJruY7teA9gao7c0bgX4pULrfB4NEQJi6c9hAuwPXAvTAwWPIs02uLguZFqad
         1vXRQzpL8wmIK0KOr07n0uL/rJ8uhfmin9vdgLXxtB0A/geeGKezO0J+XvznC0qc5bKC
         /EaECk21xZxZM24eTJkg0z5zuEWIS9HfHCzuo=
MIME-Version: 1.0
In-Reply-To: <1259077143-25864-1-git-send-email-cliffcai.sh@gmail.com>
References: <1259077143-25864-1-git-send-email-cliffcai.sh@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 24 Nov 2009 11:35:56 -0500
Message-ID: <8bd0f97a0911240835j1d360b39tda688e551052c5c7@mail.gmail.com>
Subject: Re: [PATCH][mmc/host]:Blackfin SD Host Controller Driver
To: cliffcai.sh@gmail.com
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       cliff.cai@analog.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 10:39,  <cliffcai.sh@gmail.com> wrote:
> From: Cliff Cai <cliffcai.sh@gmail.com>
>
> Signed-off-by: Cliff Cai <cliffcai.sh@gmail.com>

you dropped some people's s-o-b tags

> +out4:
> +       free_irq(host->irq, host);

you didnt address the feedback given last time here:
    You need a mmc_remove_host() here.
-mike
