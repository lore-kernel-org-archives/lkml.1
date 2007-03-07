Return-Path: <linux-kernel-owner+w=401wt.eu-S1750894AbXCGQbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750894AbXCGQbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:31:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbXCGQbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:31:08 -0500
Received: from terminus.zytor.com ([192.83.249.54]:50001 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbXCGQbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:31:07 -0500
Message-ID: <45EEE8B7.3070108@zytor.com>
Date: Wed, 07 Mar 2007 08:30:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Chen, Dongliang" <Chen.D@ems-t.com>
CC: Andreas Schwab <schwab@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: return negative number for unsigned long function in kernel
References: <314BE1148B8C8D468A05944FDF577583069B021E@MRE02.enterprise.com> <45EE09B4.40207@zytor.com> <314BE1148B8C8D468A05944FDF577583069B0222@MRE02.enterprise.com>
In-Reply-To: <314BE1148B8C8D468A05944FDF577583069B0222@MRE02.enterprise.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chen, Dongliang wrote:
> Peter & Andreas,
> 
> Thank you very much for your help. 
> 
> I understood that the kernel error numbers are limited. The largest
> error number for i386 (kernel 2.6) is 131 so far.  Assume that the
> virtual address returned from do_mmap_pgoff will never exceed (unsigned
> long)(-1000L), which is in the address range one page below the maximum
> virtual address, then IS_ERR_VALUE() should work.
> 

The error value boundary is defined in <linux/err.h>, currently 4095.

	-hpa
