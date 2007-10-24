Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbXJXRXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbXJXRXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbXJXRXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:23:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33446 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbXJXRXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:23:21 -0400
Message-ID: <471F7F28.2010805@zytor.com>
Date: Wed, 24 Oct 2007 10:21:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Rajkumar S <rajkumars@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: HIGHMEM64G Kernel (2.6.23.1) makes system crawl
References: <64de5c8b0710240326q709ca7fbq4b365bcaf6e89fb9@mail.gmail.com> <471F598C.5030903@panasas.com>
In-Reply-To: <471F598C.5030903@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> 
> From looking in source code the CONFIG_HIGHMEM64G is broken in many respects,
> in my opinion. It's really a 64-bit with 32-bit quirks enabled. Does it even
> run on None 64-bit machines? Not many! 
> 

Total and utter bullsh*t.  It runs on virtually all modern x86's since 
the P6/K7 (certain Pentium M chips being an exception).

Also, it is required for NX protection and for several of the paravirt 
environments to work.

	-hpa
