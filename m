Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbYH2HWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYH2HWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbYH2HWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:22:40 -0400
Received: from gw.goop.org ([64.81.55.164]:37945 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYH2HWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:22:39 -0400
Message-ID: <48B7A3BE.8010604@goop.org>
Date: Fri, 29 Aug 2008 00:22:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickens <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
References: <48B701FB.2020905@goop.org> <b170af450808282320g27dfa2a9mc0e14e27e215ce96@mail.gmail.com>
In-Reply-To: <b170af450808282320g27dfa2a9mc0e14e27e215ce96@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Miłecki wrote:
> I was trying my best to crash system with this patch applied and failed :)
>
> Works great.
>   

Good.

> Just wonder if I should expect any printk from
> check_for_bios_corruption? I do not see any:
>
> zajec@sony:~> dmesg | grep -i corr
> scanning 2 areas for BIOS corruption
>   

I just followed up in detail to Ingo, but I think it's because I didn't
put any checks where you would hit them.  If you suspend/resume it
should print something.

    J
