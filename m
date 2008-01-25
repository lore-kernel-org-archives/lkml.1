Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbYAYMpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbYAYMpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 07:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbYAYMog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 07:44:36 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:49997 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbYAYMoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 07:44:34 -0500
Message-Id: <001c01c85f4f$bfd128f0$41a8400a@bsd.tnes.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, "Christoph Hellwig" <hch@lst.de>
References: <20080125195938t-sato@mail.jp.nec.com> <84144f020801250317pbdafc4fnd47cc8a297194e86@mail.gmail.com>
Subject: Re: [RFC] ext3 freeze feature
Date: Fri, 25 Jan 2008 21:42:30 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I am also wondering whether we should have system call(s) for these:
> 
> On Jan 25, 2008 12:59 PM, Takashi Sato <t-sato@yk.jp.nec.com> wrote:
>> +       case EXT3_IOC_FREEZE: {
> 
>> +       case EXT3_IOC_THAW: {
> 
> And just convert XFS to use them too?

I think it is reasonable to implement it as the generic system call, as you said.
Does XFS folks think so?

Cheers, Takashi
