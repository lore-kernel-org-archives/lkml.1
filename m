Return-Path: <linux-kernel-owner+w=401wt.eu-S1759820AbXKUIde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820AbXKUIde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 03:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbXKUIdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 03:33:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099AbXKUIdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 03:33:24 -0500
Date: Tue, 20 Nov 2007 16:32:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: 2.6.24-rc3-mm1 make headers_check fails
Message-Id: <20071120163240.e54beed6.akpm@linux-foundation.org>
In-Reply-To: <4743EB52.1040205@linux.vnet.ibm.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<4743EB52.1040205@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 13:54:50 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> The make headers_check fails,
> 
>   CHECK   include/linux/usb/gadgetfs.h
>   CHECK   include/linux/usb/ch9.h
>   CHECK   include/linux/usb/cdc.h
>   CHECK   include/linux/usb/audio.h
>   CHECK   include/linux/kvm.h
> /root/kernels/linux-2.6.24-rc3/usr/include/linux/kvm.h requires asm/kvm.h, which does not exist in exported headers

hm, works for me, on i386 and x86_64.  What's different over there?
