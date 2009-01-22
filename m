Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZAVC5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZAVC5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 21:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbZAVC5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 21:57:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47733 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667AbZAVC5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 21:57:21 -0500
Message-ID: <4977E04B.2040104@zytor.com>
Date: Wed, 21 Jan 2009 18:56:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: John David Anglin <dave@hiauly1.hia.nrc.ca>
CC: grundler@parisc-linux.org, arnd@arndb.de, davem@davemloft.net,
       jaswinder@kernel.org, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
References: <20090122025209.307E54F30@hiauly1.hia.nrc.ca>
In-Reply-To: <20090122025209.307E54F30@hiauly1.hia.nrc.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John David Anglin wrote:
> 
> Unfortunately, this decision was made years ago...
> 
> dave@mx3210:~$ uname -m
> parisc64
> dave@hiauly6:~/gnu/gcc-4.4/gcc$ uname -m
> parisc
> 
> The only significant difference between the above two machines is that
> mx3210 is running a 64-bit kernel and hiauly6 is running a 32-bit kernel.
> Both are PA 2.0 machines.  Some PA 2.0 machines can only run 64-bit
> kernels.  The workstations can typically run both.
> 
> The issue for user space is that 64-bit kernels can support both 32 and
> 64-bit applications.  This affects build scripts and make files.  The
> default machine selected by config.guess for parisc64 is hppa64.
> Separate applications provide 32-bit and 64-bit support in binutils, 
> cc and gdb.  hppa64 selects 64-bit support when build these applications.
> So, if you want a 32-bit compiler, you need to explicitly override
> the default chosen by config.guess.
> 

That's fine... the whole point is that it should not depend on kernel
CONFIG_* macros.  Depending on uname is a user-space decision, no issue
there.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

