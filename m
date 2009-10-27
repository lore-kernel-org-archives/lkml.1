Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbZJ0Eme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbZJ0Eme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 00:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbZJ0Emd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 00:42:33 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57934 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbZJ0Emd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 00:42:33 -0400
Message-ID: <4AE67A2A.8060805@canonical.com>
Date: Tue, 27 Oct 2009 12:42:18 +0800
From: Bryan Wu <bryan.wu@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Eric Miao <eric.miao@canonical.com>
CC: gregkh@suse.de, kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Android logger: fix compiling error
References: <1256316741-14053-1-git-send-email-bryan.wu@canonical.com> <f17812d70910262140i63e4d2f0x708521a9287ca386@mail.gmail.com>
In-Reply-To: <f17812d70910262140i63e4d2f0x708521a9287ca386@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Miao wrote:
>> Compiling broke since commit a99bbaf5ee6bad1aca0c88ea65ec6e5373e86184
>>    headers: remove sched.h from poll.h
>>
>> Adding <linux/sched.h> to fix this compiling bug.
>>
> 
> Bryan,
> 
> Is this something caused by incorrect pxa header files?
> 

No. the commit a99bbaf5ee6bad1aca0c88ea65ec6e5373e86184 missed to fix this issue in Android driver.
It fixed others. I just added it back.

-Bryan


