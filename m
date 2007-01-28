Return-Path: <linux-kernel-owner+w=401wt.eu-S1752458AbXA1RCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbXA1RCa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 12:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbXA1RCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 12:02:30 -0500
Received: from dvhart.com ([64.146.134.43]:42142 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbXA1RCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 12:02:30 -0500
Message-ID: <45BCD713.5020806@mbligh.org>
Date: Sun, 28 Jan 2007 09:02:11 -0800
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.20-rc6-mm1
References: <20070127234928.64d8e437.akpm@osdl.org>
In-Reply-To: <20070127234928.64d8e437.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> - It seems that people have been busy creating the need for this.  I had to
>   apply over sixty patches to this tree to fix post-2.6.20-rc4-mm1 compilation
>   errors.  And a number of patches were dropped due to no-compile or to
>   runtime errors.  Heaven knows how many runtime bugs were added.

Build failure:

fs/built-in.o: In function `load_elf_binary':
binfmt_elf.c:(.text+0x32cc0): undefined reference to 
`arch_setup_additional_pages'

config:
http://test.kernel.org/abat/68517/build/dotconfig
