Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbYDWHT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbYDWHT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 03:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYDWHTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 03:19:48 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:6668 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYDWHTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 03:19:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=tr6PMIITjbGk1V3WuBeqlyNBvlXElWMB/9hArMdmRjl8sj7SXZ8yfkjbSJbyxQmehifs+/ReDTDNrs3EqgygYElsh5hCak+lS3Rv/lhO/PrayGMzfU2oGOExk3o41+FBcgvxdBdB6ACx5r9V2o8ZW4navq24AH7xZ1sCsMoL2PU=
Message-ID: <480EE32A.1040502@henry.nestler.gmail.com>
Date: Wed, 23 Apr 2008 09:20:10 +0200
From: Henry Nestler <henry.nestler@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: harvey.harrison@gmail.com
Subject: Re: [PATCH 2/2] x86: Further shrink ifdef sections in fault.c
References: <9Plf4-3KR-11@gated-at.bofh.it> <9PuLt-2sk-33@gated-at.bofh.it>
In-Reply-To: <9PuLt-2sk-33@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
>> +	if (!(address >= VMALLOC_START && address < VMALLOC_END))
>> +		return -1;
> 
> ah, this explains the weird chunk in your other patch.

Why this is not in x86_32?

Please see my other mail "x86: endless page faults in mount_block_root
for Linux 2.6", with problem without this check.

-- 
Henry N.
