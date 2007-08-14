Return-Path: <linux-kernel-owner+w=401wt.eu-S1764843AbXHNPra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764843AbXHNPra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762200AbXHNPrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:47:09 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:64985 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758915AbXHNPrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:47:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YNcPPjgLYa43h3a49GOkwSXS/MePAlz3H0HoCjgzR7KsteZUbNi2QQ46siLVyxyphBSYXQHRX01xFC5x42eGmXDHlJ6ofNGhULHULMYFimFtP3VK7FecFI84gD+34Sn3q0Dn57SY9mNeFUMz421mGmO9mPYO/N/ljVN9M+OKFj8=
Message-ID: <be1b757c0708140847g4900624oee28eb214ff7e735@mail.gmail.com>
Date: Tue, 14 Aug 2007 17:47:04 +0200
From: "Karl Meyer" <adhocrocker@gmail.com>
To: "Francois Romieu" <romieu@fr.zoreil.com>
Subject: Re: PROBLEM: 2.6.23-rc "NETDEV WATCHDOG: eth0: transmit timed out"
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070814070901.GA14693@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <be1b757c0708130435y689b9dd8raf9ac9f9c0fcc976@mail.gmail.com>
	 <20070813165821.GA19356@electric-eye.fr.zoreil.com>
	 <be1b757c0708131027v5c57822as2d9bd3190fd19b71@mail.gmail.com>
	 <20070814070901.GA14693@electric-eye.fr.zoreil.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I successfully ran git bisect:
0127215c17414322b350c3c6fbd1a7d8dd13856f is first bad commit
commit 0127215c17414322b350c3c6fbd1a7d8dd13856f
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Tue Feb 20 22:58:51 2007 +0100

    r8169: small 8101 comment

    Extracted from version 1.001.00 of Realtek's r8101.

    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
    Cc: Edward Hsu <edward_hsu@realtek.com.tw>

:040000 040000 07dc911509e8d1b4ff2dfb013401108d4be85095
d41a52a215fb1b38ba652dda90faf6ed951bccd1 M      drivers

I did proof it by doing "git revert
0127215c17414322b350c3c6fbd1a7d8dd13856f"  on my git clone, now I am
happily running 2.6.23-rc3-ge60a without the NETDEV WATCHDOG message.

2007/8/14, Francois Romieu <romieu@fr.zoreil.com>:
> Karl Meyer <adhocrocker@gmail.com> :
> [...]
> > dmesg, interrupts and .config are attached. I will have a look at git bisect.
>
> Can you reproduce the problem when nvidia binary-only stuff is not loaded
> after boot ?
>
> --
> Ueimor
>
