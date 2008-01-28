Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbYA1KT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbYA1KT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbYA1KTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:19:18 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:61641 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbYA1KTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:19:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hZCITJcHbmtw9faizFm31eXwKYf2SPohSo4yJpB8ODu/CKUcArAKrTTMdw26cUj75ZDbB9UXyIAaXsc+kVHkHjJZUzS3yfLtZnyB7ko9EA688fi697rgf7bY4thtQwKcvYje1Rfr5brjR5hwz0ZLsR9N2NPWTRQTKDPwopI++IU=
Message-ID: <8bd0f97a0801280219y724d288ci8726274a6cc943e9@mail.gmail.com>
Date: Mon, 28 Jan 2008 05:19:15 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] exposing MMR's of on-chip peripherals for debugging purposes
Cc: "Bryan Wu" <cooloney.lkml@gmail.com>
In-Reply-To: <8bd0f97a0801280216x56d52028s2ea247dd969e85e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0801280216x56d52028s2ea247dd969e85e2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 28, 2008 5:16 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> the trouble is that this file currently weighs in at ~1.8 megs.  this
> is because it contains all the information for all Blackfin processors
> we support (which currently, is about ~23 variants).  it's only going
> to get bigger as we support more.  Bryan cringes at the thought of
> submitting it to LKML :).

erp, forgot to include this ... for the curious, here is the current file:
http://blackfin.uclinux.org/gf/project/linux-kernel/scmsvn/?action=browse&path=/*checkout*/trunk/arch/blackfin/kernel/debug-mmrs.c
-mike
