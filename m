Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbZAQG1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbZAQG1G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 01:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbZAQG0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 01:26:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33047 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZAQG0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 01:26:52 -0500
Message-ID: <49717A28.2060106@zytor.com>
Date: Fri, 16 Jan 2009 22:26:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: sidc7 <siddhartha.chhabra@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel vs user memory
References: <21512362.post@talk.nabble.com>
In-Reply-To: <21512362.post@talk.nabble.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sidc7 wrote:
> The kernel maintains a free list of pages that are free in physical memory. I
> was wondering, are these pages in the kernel space ? They are not mapped to
> any of the user address space for sure, so will they be in the kernel memory
> ?

On a non-highmem kernel, they will be -- ALL memory is mapped in kernel
space on non-highmem kernels.  For highmem kernels, they will generally
not be mapped at all, unless they are lowmem pages.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

