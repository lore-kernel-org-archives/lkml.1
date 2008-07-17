Return-Path: <linux-kernel-owner+w=401wt.eu-S1760523AbYGQQA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523AbYGQQA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbYGQQAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:00:15 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1529 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbYGQQAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:00:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: ivtv-devel@ivtvdriver.org
Subject: Re: [ivtv-devel] [PATCH AVAIL.]ivtv:Crash 2.6.26 with KUROTOSIKOU CX23416-STVLP
Date: Thu, 17 Jul 2008 17:58:19 +0200
User-Agent: KMail/1.9.9
Cc: Kyuma Ohta <whatisthis.sowhat@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Video4Linux ML <video4linux-list@redhat.com>
References: <1216308014.1146.22.camel@melchior>
In-Reply-To: <1216308014.1146.22.camel@melchior>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807171758.19702.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 July 2008 17:20:14 Kyuma Ohta wrote:
> Hi,
> I'm testing 2.6.26/amd64 with Athlon64 x2 Box with
> KUROTOSIKOU CX23416-STVLP,always crash ivtv driver
> when loading upd64083 driver.
> I checked crash dump,this issue cause of loading
> upd64083.ko with i2c_probed_new_device().
> So,I fixed ivtv-i2c.c of 2.6.26 vanilla,and
> fixed *pretty* differnce memory allocation,structure
> of upd64083.c.
> I'm running patched 2.6.26 vanilla with below attached
> patches over 24hrs,and over 10hrs recording from ivtv,
> not happend anything;-)
> Please apply below to 2.6.26.x..
>
> Best regards,
> Ohta.

Hi Ohta,

Thanks for the patches. If I'm not mistaken there are several variants 
of this card: without upd* devices, only with upd64083 and with both 
upd devices. Which one do you have?

Can you also show the dmesg output when ivtv loads?

Looking at the four patches, I would say that the only relevant patch is 
the fix-probing patch. If you try it with only that one applied, does 
it still work correct for you? Note that this patch will not work with 
a KUROTOSIKOU card that has no upd* devices at all.

Can you also give me the kernel backtrace when you load ivtv with the 
vanilla 2.6.26? I do not quite understand why it should crash.

Regards,

	Hans
