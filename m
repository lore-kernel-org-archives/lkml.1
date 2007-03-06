Return-Path: <linux-kernel-owner+w=401wt.eu-S932980AbXCFIhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbXCFIhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932993AbXCFIhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:37:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:55583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980AbXCFIhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:37:20 -0500
Message-ID: <45ED2837.3020108@suse.de>
Date: Tue, 06 Mar 2007 09:37:11 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen & VMI?
References: <20070305120631.GA14105@elte.hu>	<1173101297.26165.39.camel@localhost.localdomain>	<1173142644.4644.6.camel@localhost.localdomain>	<45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org>	<45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu>
In-Reply-To: <20070306081909.GA9331@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> btw., while we have everyone on the phone and talking ;) Technologically 
> it would save us a whole lot of trouble in Linux if 'external' 
> hypervisors could standardize around a single ABI - such as VMI. Is 
> there any deep reason why Xen couldnt use VMI to talk to Linux? I 
> suspect a range of VMI vectors could be set aside for Xen's dom0 (and 
> other) APIs that have no current VMI equivalent - if there's broad 
> agreement on the current 60+ base VMI vectors that center around basic 
> x86 CPU capabilities - which make up the largest portion of our 
> paravirtualization complexity. Pipe dream?

IIRC there was some proof-of-concept at least for xen guests.

> there are already 5 major hypervisors we are going to support (in 
> alphabetical order):
> 
>  - KVM
>  - lguest
>  - Windows
>  - VMWare
>  - Xen
> 
> the QA matrix is gonna be a _mess_.

I fail to see how xen-via-vmirom instead of xen-via-paravirt_ops reduces
the QA effort.  You still have 5 Hypervisors you have to test against.

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
