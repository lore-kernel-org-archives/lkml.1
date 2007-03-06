Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXCFIsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXCFIsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932911AbXCFIsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:48:45 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:34868 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932978AbXCFIso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:48:44 -0500
Message-ID: <45ED2AE7.80407@vmware.com>
Date: Tue, 06 Mar 2007 00:48:39 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Xen & VMI?
References: <20070305120631.GA14105@elte.hu>	<1173101297.26165.39.camel@localhost.localdomain>	<1173142644.4644.6.camel@localhost.localdomain>	<45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org>	<45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de>
In-Reply-To: <45ED2837.3020108@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
> I fail to see how xen-via-vmirom instead of xen-via-paravirt_ops reduces
> the QA effort.  You still have 5 Hypervisors you have to test against.
>   

You've also got a frozen, multi-vendor binary interface, which was the 
straw which broke our original intentions for VMI.  Try as you can, you 
cannot get around this, and there is just no way that list of players 
are going to remain friendly and happy with each other (embrace, extend, 
conquer, anyone?).  There are already differences with VMI / lhype and 
Xen (shadow vs. direct page tables), and also with KVM vs VMI / Xen / 
lhype (required HVM vs optional HVM).  Like it or not, incompatible 
changes will happen, and with no official standard body to mediate so 
that it can't be dominated by one party, I don't see how it can work.  
Which is why I now prefer the flexible in kernel API of paravirt-ops.

Zach
