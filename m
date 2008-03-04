Return-Path: <linux-kernel-owner+w=401wt.eu-S1762685AbYCDL1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762685AbYCDL1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 06:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYCDL1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 06:27:15 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:41064 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbYCDL1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 06:27:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ObFT+sNCxvxaZtIYeLs4mn8v5Wm3Yi0oAgkpb1dxdIdNpt9jVITohoBeh/i2O1KWWUAR85HtHTWkt5BN+q/iAeHajMSJ/v0RXZIsfcnn9IK6eN5HUTZ/Lm7ZBg9I3k+FEteKozjkZ8qnBLx/G7X7Cobbg1hZxmE27CTfMYqbALA=
Message-ID: <8bd0f97a0803040327i522e2291j7e8149f7eb5a152f@mail.gmail.com>
Date: Tue, 4 Mar 2008 06:27:13 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Hirofumi Nakagawa" <hnakagawa@miraclelinux.com>
Subject: Re: [PATCH] Remove duplicated unlikely() at IS_ERR()
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47CD0DD7.8010306@miraclelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47CD0582.4080407@miraclelinux.com>
	 <47CD0DD7.8010306@miraclelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2008 at 3:52 AM, Hirofumi Nakagawa
<hnakagawa@miraclelinux.com> wrote:
> From 3fd86d4898df10ee0b8884b5a31a512cb90f3362 Mon Sep 17 00:00:00 2001
>  Some drivers have duplicated unlikely() macros.
>  IS_ERR() already has unlikely() in itself.
>  This patch cleans up such pointless codes although there is no real
>  effect on the kernel's behaviour.
>
>   drivers/rtc/rtc-bfin.c          |    2 +-

thanks, the Blackfin bit looks good to me

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
