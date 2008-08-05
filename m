Return-Path: <linux-kernel-owner+w=401wt.eu-S1761323AbYHELVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbYHELVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYHELVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:21:07 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:51282 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbYHELVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:21:05 -0400
Message-ID: <4898379D.2060709@aitel.hist.no>
Date: Tue, 05 Aug 2008 13:21:01 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Eric Paris <eparis@redhat.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface	for
 on access scanning
References: <1217883616.27684.19.camel@localhost.localdomain> <20080804223249.GA10517@kroah.com>
In-Reply-To: <20080804223249.GA10517@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>
>
> I don't see anything in the list above that make this a requirement that
> the code to do this be placed within the kernel.
>
> What is wrong with doing it in glibc or some other system-wide library
> (LD_PRELOAD hooks, etc.)?
>   

A linux virus would trivially get around that by doing its own syscalls
instead of using glibc. (It might still link dynamically to glibc so
you don't get suspicious, but won' actually use it when doing bad stuff.)

Helge Hafting
