Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbZDOVat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbZDOVat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZDOVak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:30:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48159 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZDOVak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:30:40 -0400
Message-ID: <49E651A9.8030409@zytor.com>
Date: Wed, 15 Apr 2009 14:29:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Gregory Haskins <ghaskins@novell.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       henrix@sapo.pt
Subject: Re: Trouble with make-install from a NFS mount
References: <49E500F6.8060401@novell.com> <49E501D4.6000605@oracle.com> <49E627AA.5080105@novell.com> <49E641D4.2000604@oracle.com> <49E64DE1.8070909@novell.com> <20090415212009.GA27597@uranus.ravnborg.org>
In-Reply-To: <20090415212009.GA27597@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> The problem seems to be that 30-rcX thinks that there are dependencies
>> to update (such as include/config/kernel.release and version.h.tmp)
>> during a make-install operation.  Since I am on a root-squashed NFS
>> mount, these files cannot be updated and thus the install fails. 
>> Previous trees prior to linux-current (at least up to 2.6.29) did not
>> try to update these files so the install would succeed.
> 
> It is because arch/x86/Makefile has
> a dependency on vmlinux for the install target.
> 
> I know hpa has had a fix for it but it is not applied.
> I recall there was a trivial bug in the first version.
> 

OK, do we have a consensus that this is desirable?  I was somewhat 
confused if it was desired or considered user error.

I'll clean up the patch and add it in the former case.

	-hpa

