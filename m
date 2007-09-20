Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbXITLjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbXITLjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 07:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXITLjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 07:39:06 -0400
Received: from mail.syneticon.net ([213.239.212.131]:32887 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbXITLjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 07:39:04 -0400
Message-ID: <46F25BCD.2070005@wpkg.org>
Date: Thu, 20 Sep 2007 13:38:53 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: patch/option to wipe memory at boot?
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there a patch or a boot option or something which wipes all
> available (physical) RAM at boot (or better, fills it with a fixed
> signature like 0xdeadbeef)?  I'm getting phony ECC errors and I'd like
> to test whether they go away when the RAM is properly initialized.
> Also, I'd like to know exactly which parts of RAM are being used and
> which are untouched since boot (hence the 0xdeadbeef signature).
> 
> If this patch/option doesn't exist, can anyone give me a hint as to
> where and how it would be best to add this?  (I'm afraid I'm very
> ignorant as to how Linux sets up its RAM mapping.)  I'm concerned
> about x86 and x86_64.
> 
> PS: I'm not finicky: it's all right if a couple of megabytes at the
> bottom of RAM are not scrubbed (I'm more interested about the top
> gigabyte-or-so), especially if they're guaranteed to be used by the
> kernel.

As a side note to what others said, you can always use initrd/initramfs 
to start your favourite program that wipes the memory...


-- 
Tomasz Chmielewski
http://blog.wpkg.org


