Return-Path: <linux-kernel-owner+w=401wt.eu-S1761630AbXERXIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630AbXERXIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 19:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbXERXIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 19:08:48 -0400
Received: from terminus.zytor.com ([192.83.249.54]:55762 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbXERXIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 19:08:47 -0400
Message-ID: <464E31F8.7010701@zytor.com>
Date: Fri, 18 May 2007 16:08:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070507)
MIME-Version: 1.0
To: Philipp Kohlbecher <pk031698@uni-greifswald.de>
CC: Dave Jones <davej@codemonkey.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, linux-assembly@vger.kernel.org
Subject: Re: [PATCH 2.6.21.1] i386: save registers before intra-privilege
 syscall
References: <20070517220638.GA6532@localhost.localdomain> <464CD44A.5000307@zytor.com> <464CE4CA.8000704@uni-greifswald.de> <464CE653.4020006@zytor.com> <464D64B2.6050104@uni-greifswald.de> <464E2B97.9040205@zytor.com>
In-Reply-To: <464E2B97.9040205@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Sticking kernel mode values in those fields would add no value, except
> as a poison (since %ss == KERNEL_DS and would cause a #GP(0) if it ever
> reached IRET.)

#SS(0), rather, of course.

	-hpa
