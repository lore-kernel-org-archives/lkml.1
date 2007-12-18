Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbXLRWJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbXLRWJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbXLRWJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:09:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:6531 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbXLRWJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:09:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kYZd/ISYIHXtam1u+5m984P6DJNMdJauDMyOTxifeajVzbOeYeIivEnqccS590lo0Omyv+vLvjBl7KLWqsqa4L4RvMHlCRBuivjC85dY0z46ilau5721cRtlYK2kVzQ2pr4X1PIppO8Yoa6H8K0zlvXLxVa/8KfO8PHs6388Zo0=
Message-ID: <9e0cf0bf0712181409p2475e1fdk779fdee4fa274722@mail.gmail.com>
Date: Wed, 19 Dec 2007 00:09:46 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [MIPS] Build an embedded initramfs into mips kernel
Cc: linux-mips@ftp.linux-mips.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47683B2D.9030608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e0cf0bf0712181208m7f16b9acpf3dba67f3556a613@mail.gmail.com>
	 <47683B2D.9030608@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Make sure your /init doesn't depend on an interpreter or library which
> isn't available.

Thank you for your answer.

I already checked.

/init is hardlink to busybox, it depends on libc.so.0 which is available at /lib

But shouldn't I get a different error code if this is the case?

Best Regards,
Alon Bar-Lev.
