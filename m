Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbYDDSGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbYDDSGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 14:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbYDDSGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 14:06:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57215 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYDDSG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 14:06:29 -0400
Message-ID: <47F66E10.8030405@zytor.com>
Date: Fri, 04 Apr 2008 11:06:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>
Subject: Re: kernel/time.c: integer constant is too large for 'long' type
 warnings
References: <47F65AE6.4050500@googlemail.com>
In-Reply-To: <47F65AE6.4050500@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Hi,
> 
> with CONFIG_HZ_300=y I see these warnings :
> 
> kernel/time.c: In function 'msecs_to_jiffies':                                                                                                               
> kernel/time.c:472: warning: integer constant is too large for 'long' type                                                                                    
> kernel/time.c: In function 'usecs_to_jiffies':                                                                                                               
> kernel/time.c:487: warning: integer constant is too large for 'long' type
> 
> I think this was introduced by :
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=bdc807871d58285737d50dc6163d0feb72cb0dc2
> 
> If you need more infos let me know.
> 

There is a patch for this, already, but the bikeshed painters have been 
whining about it.

The code is correct; it is a nuisance warning only.

	-hpa
