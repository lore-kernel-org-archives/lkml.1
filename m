Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbYABII1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbYABII1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 03:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYABIIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 03:08:18 -0500
Received: from mail1.asahi-net.or.jp ([202.224.39.197]:13014 "EHLO
	mail.asahi-net.or.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752577AbYABIIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 03:08:17 -0500
Message-ID: <477B468A.3050702@kaigai.gr.jp>
Date: Wed, 02 Jan 2008 17:08:42 +0900
From: KaiGai Kohei <kaigai@kaigai.gr.jp>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morgan <morgan@kernel.org>
CC: KaiGai Kohei <kaigai@ak.jp.nec.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       jmorris@namei.org, akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exporting capability code/name pairs
References: <477321C8.3070004@ak.jp.nec.com> <20071227161435.GB9677@sergelap.austin.ibm.com> <477455A0.7060603@ak.jp.nec.com> <477494C3.2040301@ak.jp.nec.com> <4777C745.8080700@kernel.org>
In-Reply-To: <4777C745.8080700@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morgan wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> KaiGai Kohei wrote:
>> Remaining issues:
>> - We have to mount securityfs explicitly, or use /etc/fstab.
>>   It can cause a matter when we want to use this feature on
>>   very early phase on boot. (like /sbin/init)
> 
> I'm not altogether clear how you intend this to work.
> 
> Are you saying that some future version of libcap will require that
> securityfs be mounted before it (libcap) will work?

Yes, but implementing this feature on securityfs might be not good
idea as as James said. If this feature is on procfs or sysfs, it is
not necessary to mount securityfs explicitly.

Thanks,
-- 
KaiGai Kohei <kaigai@kaigai.gr.jp>
