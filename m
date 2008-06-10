Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbYFJX5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbYFJX5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 19:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYFJX44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 19:56:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:15185 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbYFJX4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 19:56:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QulpJUotSQ2VJPDeVh+m2tYPhG2hMlSypGubz1HLKJeUkOjQqGLRi39TWcVraE/Ut2
         9ke9F2p8aQNWkLnPjKtpxL8TJrFBnoYPJ/STp2c4G5QQNYyY7woiapIMOoLCSyBtnm9B
         S3aTr829x2jFRNOLWA4yJvIGRkimTj3APxai0=
Message-ID: <484F14B5.4090204@gmail.com>
Date: Tue, 10 Jun 2008 20:56:37 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Warning when compiling arch/x86/mm/init_64.c on x86_64
References: <484EED06.8060301@lwfinger.net>
In-Reply-To: <484EED06.8060301@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> Since commit 511631011d39706ac81ee5e4c9084d61e5b4fd34, entitled
> "x86: fix pointer type warning in arch/x86/mm/init_64.c:early_memtest", the 
> following warning is produced for x86_64:
> 
> arch/x86/mm/init_64.c: In function ‘early_memtest’:
> arch/x86/mm/init_64.c:520: warning: passing argument 2 of 
> ‘find_e820_area_size’ from incompatible pointer type
> 
> Before this commit, the compilation of this routine on my system was clean. I 
> use gcc version 4.2.1. Was this the warning for i386 before the patch? I 
> tried simple changes in the definition of find_e820_area_size, but only 
> managed to push the warning on to the call to bad_addr_size. At that point I 
> decided to let the experts find a proper fix. Note that the warning does no 
> harm - I just get nervous about incompatible pointer warnings as it usually 
> means that I have screwed something up.
> 

The patch was against linux-next, which seems to have changed 
find_e820_area_size() - against mainline it introduced the warning 
instead of fixing it.

-- 
Kevin Winchester

