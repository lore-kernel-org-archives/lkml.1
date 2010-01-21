Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751Ab0AUJOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0AUJOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 04:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216Ab0AUJOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 04:14:16 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:46271 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab0AUJOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 04:14:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tfQYj2CmHmpohu//6Y2pMtYKrw2QgF2B5WyTn/AY0RNgLID8NtZneM1+50vNO6sJOu
         qG5UFaVOazZPIhARO2jKNU+fgUhvdf+0BJwYPP0+W2Kfh3xRqcy8qX79yVAcjF7sR9It
         71ephIGp3k5107THJtTKOD0sK4IZMck4Udjo4=
MIME-Version: 1.0
In-Reply-To: <1264064527.4283.1139.camel@laptop>
References: <86802c441001201710heee6a1g744f69f4edcbc52c@mail.gmail.com>
	 <1264062159.4283.1125.camel@laptop>
	 <7b6bb4a51001210046mdb48624xf3efc8bf756efb40@mail.gmail.com>
	 <1264064527.4283.1139.camel@laptop>
Date: Thu, 21 Jan 2010 17:14:14 +0800
Message-ID: <7b6bb4a51001210114g1b2ec290g3fdf098a651b6b38@mail.gmail.com>
Subject: Re: qlogic lockdep warning
From: Xiaotian Feng <xtfeng@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       James.Bottomley@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 5:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-01-21 at 16:46 +0800, Xiaotian Feng wrote:
>> qla24xx_msix_default is using spin_lock_irq and spin_unlock_irq within
>> the irq handler...
>> I think convert to spin_lock_irqsave/spin_unlock_irqrestore can solve
>> this warning.
>
> Not only that it'll actually solve a bug too ;-)
>
> Also,
>
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?

Ah, just realized it by your examples :-) Sorry for the bad manner in e-mail...

>
>
