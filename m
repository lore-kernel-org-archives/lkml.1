Return-Path: <linux-kernel-owner+w=401wt.eu-S932946AbXBTNLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946AbXBTNLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 08:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932945AbXBTNLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 08:11:30 -0500
Received: from smtp.nokia.com ([131.228.20.171]:17192 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946AbXBTNL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 08:11:29 -0500
Subject: Re: [PATCH 03/44 take 2] [UBI] user-space API header
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <200702172227.28708.arnd@arndb.de>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165439.5845.66537.sendpatchset@localhost.localdomain>
	 <200702172227.28708.arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Feb 2007 15:07:13 +0200
Message-Id: <1171976833.4039.30.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Feb 2007 13:07:13.0714 (UTC) FILETIME=[09D44920:01C754F0]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070220150505-1BCD9BB0-0D024612/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 22:27 +0100, Arnd Bergmann wrote:
> On Saturday 17 February 2007 17:54, Artem Bityutskiy wrote:
> > +struct ubi_mkvol_req {
> > +       int32_t vol_id;
> > +       int32_t alignment;
> > +       int64_t bytes;
> > +       int8_t vol_type;
> > +       int8_t padding[9];
> > +       int16_t name_len;
> > +       __user const char *name;
> > +} __attribute__ ((packed));
> 
> This structure is not suitable for an ioctl call, because it has
> incompatible layout between 32 and 64 bit processes. The easiest
> fix for this would be to change the 'name' field to an array
> instead of a pointer.

Will be fixed thanks. Just out of curiosity, could you please provide an
example when this may be a problem.

Artem.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

