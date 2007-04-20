Return-Path: <linux-kernel-owner+w=401wt.eu-S2992635AbXDTIpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992635AbXDTIpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992687AbXDTIpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:45:10 -0400
Received: from main.gmane.org ([80.91.229.2]:42135 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992635AbXDTIpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:45:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: Dropping CONFIG_REORDER on x86-64 for 2.6.22
Date: Fri, 20 Apr 2007 09:35:10 +0100
Message-ID: <yw1x4pnba1fl.fsf@thrashbarg.mansr.com>
References: <200704191354.52985.ak@suse.de> <46277C36.6030301@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: agrajag.inprovide.com
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (Double Solitaire, linux)
Cancel-Lock: sha1:FYQYStSr3hbfZeaRcmck8I2p44A=
Cc: discuss@x86-64.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@linux.intel.com> writes:

> Andi Kleen wrote:
>> Rationale:
>> - It cannot be enabled in normal builds because all current lds
>> become very slow when they have to handle thousands of sections.
>>
>
> afaik this is only ever reported on SuSE; I've not heard it on any
> other distro...

Even with that option set, the full kernel build with my configuration
finishes in one minute flat on my Gentoo box.  Could it be that the
linker uses enormous amounts of memory?  I have 4GB so I wouldn't
immediately notice.

-- 
Måns Rullgård
mans@mansr.com

