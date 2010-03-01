Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab0CAQqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:46:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52994 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab0CAQqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:46:44 -0500
Message-ID: <4B8BEF71.5040105@zytor.com>
Date: Mon, 01 Mar 2010 08:46:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Graeme Russ <graeme.russ@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86 embedded - Problem getting past 'move compressed kernel 
 before decompression'
References: <4B80946D.1030503@gmail.com> <4B80C892.9000303@zytor.com>	 <4B80CA55.3040402@zytor.com> <d66caabb1002211451s5a68565fue6096e17b99402f7@mail.gmail.com> <4B88A865.2080009@gmail.com> <4B8BAB5C.5030707@gmail.com>
In-Reply-To: <4B8BAB5C.5030707@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 03:56 AM, Graeme Russ wrote:
> 
> I have done a little more digging. By adding an ascii string before
> relocated: label, I am able to determine that the int3 after the relocated:
> label exists in bzImage at offset 0x1C3FD7
> 
> EAX holds (for the jump) 0x5379d0 (different bzImage of course). The
> contents of memory at this address is in bzImage at offset 0x1C09D7 - A
> difference of 0x3600 (seems too even to be random)
> 
> I'm obviously doing something hideously wrong, but what?
> 

0x3600 sounds like the size of the real-mode code in bzImage.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

