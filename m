Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbYBFPqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbYBFPqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 10:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYBFPqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 10:46:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:16346 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbYBFPqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 10:46:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=wjbGYuohXAM2u1e1PtBhbKc/x/HmXnRuErNIkpmwP/1YlvuCne9NsDLVtXSOqLCUF7XDB2a3WIIIog5fzavRUrhpPJVbSImUriyY+lI/Inr2Ydw00P/xZg3Q1IOs9Sf9s3x4S/xjmER/KJ7bG5e+y+wbi5WD6otm1Fd2VWzHb0g=
Message-ID: <b6c5339f0802060746m3a5f87edj4465797564430292@mail.gmail.com>
Date: Wed, 6 Feb 2008 10:46:39 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Jiri Slaby" <jirislaby@gmail.com>, "Tino Keitel" <tino.keitel@gmx.de>,
       linux-kernel@vger.kernel.org, ath5k-devel@lists.ath5k.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-wireless@vger.kernel.org
Subject: Re: [RFT 1/1] single_chip test
In-Reply-To: <20080206150043.GA6921@nineveh.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080206014131.9d489a34.akpm@linux-foundation.org>
	 <1202294560-7313-1-git-send-email-jirislaby@gmail.com>
	 <20080206150043.GA6921@nineveh.local>
X-Google-Sender-Auth: 9038d222c4887141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We failed to resume after a hardware reset here for a whole second. Is there any
> > version of ath5k which worked for you (is this a regression)?
>
> I cannot speak for Tino, but my ath5k never worked in MacBook -- it
> failed the same way, and I believe the hardware was the same.  My
> understanding was that it was a known bug with PCIE devices, but I got
> that out of reading list archives.

Nick Kossifidis and I are in the process of debugging this -- we
determined that AR5K_RESET_CTL_PCI hangs the card in hw_nic_wakeup.
It doesn't look like there is any general support for 5424 cards yet.
Thread is at:

    http://marc.info/?l=linux-wireless&m=120179743111458

-Bob
