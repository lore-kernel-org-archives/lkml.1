Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbYGHQ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbYGHQ4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYGHQ4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:56:04 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:56527 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbYGHQ4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:56:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZslvuONjkiFDkiom9YrVly4uB3Fp5YGJyojpk4vmWrGIrd/u67B+nODFArVnZA2Dnz
         cHTRlKcyVeVTcAeMxRNMZNEFRifWw8kUmyxzyMHeoSF52KF/lzoy1GhaKbAQex5dROj1
         jnMI1IZX/Y/hyYnK+DSMSAiABDDTzj/UL7Vl4=
Message-ID: <a4423d670807080956m4aa548b7vf5557892aae81432@mail.gmail.com>
Date: Tue, 8 Jul 2008 20:56:00 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Ian Romanick" <ianr@q7.com>
Subject: Re: [PATCH] drm_memory.h: remove double inclusion of linux/vmalloc.h
Cc: "Mark Asselstine" <asselsm@gmail.com>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080708152225.GA9028@q7.q7.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670807060431w639f0b1ajcbad6471d50ef802@mail.gmail.com>
	 <919fe2b30807080529j71ae1816sc035c90b5eee555c@mail.gmail.com>
	 <20080708152225.GA9028@q7.q7.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/8 Ian Romanick <ianr@q7.com>:
> On Tue, Jul 08, 2008 at 08:29:57AM -0400, Mark Asselstine wrote:
>> On Sun, Jul 6, 2008 at 7:31 AM, Alexander Beregalov
>> <a.beregalov@gmail.com> wrote:
>> > From: Alexander Beregalov <a.beregalov@gmail.com>
>> >
>> >  #if __OS_HAS_AGP
>> >
>> > -#include <linux/vmalloc.h>
>> > -
>>
>> Why remove this one and not the one at the top of the file? As well
>
> I would assume this one is removed because it is inside additional
> ifdefs.
Yes, it does not change functionality of the code.
>
>> this file has #include of drmP.h, yet drmP.h is the only file I can
>> find that includes drm_memory.h. Based on this I would think there is
>> some additional cleanup that can go on here.
How it can be cleaned up? Do you mean to move `define PAGE_AGP` to drmP.h?
