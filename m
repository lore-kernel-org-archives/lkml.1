Return-Path: <linux-kernel-owner+w=401wt.eu-S933220AbXCFKXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbXCFKXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933217AbXCFKXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:23:12 -0500
Received: from ns.suse.de ([195.135.220.2]:45894 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933220AbXCFKXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:23:11 -0500
Message-ID: <45ED4117.40701@suse.de>
Date: Tue, 06 Mar 2007 11:23:19 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Avi Kivity <avi@argo.co.il>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen & VMI?
References: <20070305120631.GA14105@elte.hu> <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <45ED3121.8090308@suse.de> <45ED3A8D.9090906@argo.co.il>
In-Reply-To: <45ED3A8D.9090906@argo.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Gerd Hoffmann wrote:
>> Oh, and btw:  What was the reason why kvm paravirtualization doesn't use
>> the vmi interface?
>>
>>   
> 
> There actually was proof of concept code to do just that (by Anthony
> Liguori).  For Linux, I feel paravirt_ops is superior as we can extend
> it if something is missing.

Thanks.  That is actually the point I want make: although it is
*possible* to do that via VMI ROM, doing that using paravirt_ops is
*better* (no matter whenever the hypervisor is xen or kvm).  Thats why
we actually have it.  The very same discussion a couple months ago came
to  exactly that conclusion.

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
