Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053Ab0A1QWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0A1QWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 11:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962Ab0A1QWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 11:22:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50505 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab0A1QWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 11:22:50 -0500
Date: Thu, 28 Jan 2010 17:22:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PNP PS/2 probing racy?
Message-ID: <20100128162248.GF14636@basil.fritz.box>
References: <20100128135405.GA28931@basil.fritz.box> <DE24773B-F00A-4866-8E88-AE63E6135743@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE24773B-F00A-4866-8E88-AE63E6135743@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 07:57:47AM -0800, Dmitry Torokhov wrote:
>> Hi,
>>
>> I noticed that on one test system of machine when booting the same
>> kernel I get:
>>
>> PNP: No PS/2 controller found. Probing ports directly.
>> serio: i8042 KBD port at 0x60,0x64 irq 1
>> serio: i8042 AUX port at 0x60,0x64 irq 12
>>
>> and sometimes on another boot
>>
>> PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
>>
>> Since I presume the BIOS does not change, is it possible the Linux
>> procedure for this PNP probe is racy? I haven't checked the code so far.
>>
>
> Are you using KVM with that box by any chance?

Yes, it uses a KVM, but the console was always on it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
