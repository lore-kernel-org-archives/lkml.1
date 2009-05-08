Return-Path: <linux-kernel-owner+w=401wt.eu-S1763375AbZEHVOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763375AbZEHVOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZEHVOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:14:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52809 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbZEHVOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:14:24 -0400
Message-ID: <4A049F80.2090400@zytor.com>
Date: Fri, 08 May 2009 14:09:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 09/14] x86, boot: add new runtime_address and runtime_size
 bzImage fields
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-10-git-send-email-hpa@linux.intel.com> <20090508075516.GF12808@uranus.ravnborg.org>
In-Reply-To: <20090508075516.GF12808@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>>  	@:
>> @@ -50,6 +53,9 @@ suffix_$(CONFIG_KERNEL_GZIP)  = gz
>>  suffix_$(CONFIG_KERNEL_BZIP2) = bz2
>>  suffix_$(CONFIG_KERNEL_LZMA)  = lzma
> 
> No need for a recursive assignment here. Use ":="
> Ann we usually uses "-y" not "_y".
> 

Wasn't part of the patch, but OK :)

	-hpa
