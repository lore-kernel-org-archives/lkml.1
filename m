Return-Path: <linux-kernel-owner+w=401wt.eu-S966520AbZLHVz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966520AbZLHVz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966382AbZLHVzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:55:54 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:41590 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966308AbZLHVzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:55:53 -0500
MIME-Version: 1.0
In-Reply-To: <20091208213727.GA4164@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
	 <4B1EB57D.6070408@bluewatersys.com> <20091208213727.GA4164@elf.ucw.cz>
Date: Tue, 8 Dec 2009 13:56:00 -0800
Message-ID: <d6200be20912081356i57793417u7bfb2b851fc22521@mail.gmail.com>
Subject: Re: GPIO support for HTC Dream
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 1:37 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> > +#undef MODULE_PARAM_PREFIX
>> > +#define MODULE_PARAM_PREFIX "board_dream."
>>
>> This looks a bit dodgy. Is this
>> (http://lkml.indiana.edu/hypermail/linux/kernel/0903.0/02768.html) the
>> preferred way?
>
> I don't think that would help that much here....

That should work, but you have to use board_trout, not board_dream.
Many of these parameters passed on the kernel command-line by the
bootloader which uses board_trout. Others are used by userspace which
also expects to find them under board_trout.

-- 
Arve Hjønnevåg
