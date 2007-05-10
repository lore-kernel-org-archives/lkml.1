Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbXEJIuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbXEJIuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbXEJIun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:50:43 -0400
Received: from mail.syneticon.net ([213.239.212.131]:43069 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562AbXEJIum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:50:42 -0400
Message-ID: <4642DC89.7080007@wpkg.org>
Date: Thu, 10 May 2007 10:49:13 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:

> On Wed, 2007-05-09 at 23:21 -0700, Andrew Morton wrote:
>> Well that's attractive-looking code.
> 
> It's compression code. I've never seen compression code look nice :)
> 
>> Why is this needed?  What code plans to use it?
> 
> I'm itching to use it in JFFS2. Richard claims a 10% boot time speedup
> and 40% improvement on file read speed, with only a slight drop in the
> file compression ratio (when compared to zlib).

Would be interesting to have it as a shared base for 
planned-for-May-2020 "compressed tmpfs" (and, perhaps a filesystem with 
compression, which seems even harder to engineer properly).


-- 
Tomasz Chmielewski

