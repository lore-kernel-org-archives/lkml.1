Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYFJSEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYFJSEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYFJSEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:04:12 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:47187 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYFJSEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:04:11 -0400
Date: Tue, 10 Jun 2008 14:01:10 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] [PATCH -mm 2/2] kexec jump -v11: save/restore device
 state
In-reply-to: <1213082106.22608.30.camel@caritas-dev.intel.com>
X-X-Sender: lenb@localhost.localdomain
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Message-id: <alpine.LFD.1.10.0806101400090.14381@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1213082106.22608.30.camel@caritas-dev.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 10 Jun 2008, Huang, Ying wrote:

> This patch implements devices state save/restore before after kexec.
> 
> 
> This patch together with features in kexec_jump patch can be used for
> following:
> 
> - A simple hibernation implementation without ACPI support. You can
>   kexec a hibernating kernel, save the memory image of original system
>   and shutdown the system. When resuming, you restore the memory image
>   of original system via ordinary kexec load then jump back.

What part of ACPI's role in hibernation are you trying to avoid
1. enabling wake devices
2. removing power from the system
3. something else?

thanks,
-Len
