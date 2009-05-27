Return-Path: <linux-kernel-owner+w=401wt.eu-S1759787AbZE0Iay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787AbZE0Iay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758981AbZE0Iaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:30:39 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:53120 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758942AbZE0Iai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:30:38 -0400
MIME-Version: 1.0
In-Reply-To: <20090527081732.GB3777@sortiz.org>
References: <20090526140423.GA14683@sortiz.org> <ac3eb2510905260711hb273541i8d69128b88933f7f@mail.gmail.com> 
	<20090526132351.9805f1e8.akpm@linux-foundation.org> <20090527115748.9ff0bad1.sfr@canb.auug.org.au> 
	<20090527081732.GB3777@sortiz.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 27 May 2009 10:30:19 +0200
Message-ID: <ac3eb2510905270130m752eb6bo767f7f3817cb1742@mail.gmail.com>
Subject: Re: [PATCH] firmware: Allocate firmware id dynamically
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, holtmann@linux.intel.com,
       yi.zhu@intel.com, linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       greg@kroah.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:17, Samuel Ortiz <sameo@linux.intel.com> wrote:

>> next-20090526:samples/firmware_class/firmware_sample_firmware_class.c
> Do I really need to fix this one too ?

I does not compile since ages, it is totally outdated and uses the
long removed struct class_device. And we really don't need an example
for firmware loading, I think. This file should just be deleted.

Thanks,
Kay
