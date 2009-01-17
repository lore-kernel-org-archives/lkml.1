Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbZAQGjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbZAQGjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 01:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZAQGjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 01:39:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59858 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZAQGjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 01:39:02 -0500
Message-ID: <49717D03.2030205@zytor.com>
Date: Fri, 16 Jan 2009 22:38:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: sidc7 <siddhartha.chhabra@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel vs user memory
References: <21512362.post@talk.nabble.com> <49717A28.2060106@zytor.com> <21513615.post@talk.nabble.com>
In-Reply-To: <21513615.post@talk.nabble.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sidc7 wrote:
> If I am not mistaken, Linux kernel is a high memory kernel, hence for Linux
> kernel, nothing will be mapped to the kernel space, other than the memory
> beyond 896MB which is the kernel's virtual address space. Am I right on
> this?

It's a compilation option, and depends on the architecture.  What you
described is true for an i386 kernel compiled as a highmem kernel.  On
the other hand, a 64 bit kernel is *never* highmem.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

