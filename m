Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbXLRWSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbXLRWSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbXLRWSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:18:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbXLRWSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:18:02 -0500
Message-ID: <4768459A.3000003@zytor.com>
Date: Tue, 18 Dec 2007 14:11:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alon Bar-Lev <alon.barlev@gmail.com>
CC: linux-mips@ftp.linux-mips.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [MIPS] Build an embedded initramfs into mips kernel
References: <9e0cf0bf0712181208m7f16b9acpf3dba67f3556a613@mail.gmail.com>	 <47683B2D.9030608@zytor.com> <9e0cf0bf0712181409p2475e1fdk779fdee4fa274722@mail.gmail.com>
In-Reply-To: <9e0cf0bf0712181409p2475e1fdk779fdee4fa274722@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alon Bar-Lev wrote:
> On 12/18/07, H. Peter Anvin <hpa@zytor.com> wrote:
>> Make sure your /init doesn't depend on an interpreter or library which
>> isn't available.
> 
> Thank you for your answer.
> 
> I already checked.
> 
> /init is hardlink to busybox, it depends on libc.so.0 which is available at /lib
> 
> But shouldn't I get a different error code if this is the case?

Don't think so.

	-hpa
