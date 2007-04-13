Return-Path: <linux-kernel-owner+w=401wt.eu-S964865AbXDMUNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865AbXDMUNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964988AbXDMUNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:13:36 -0400
Received: from gw.goop.org ([64.81.55.164]:33510 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964865AbXDMUNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:13:35 -0400
Message-ID: <461FE448.70605@goop.org>
Date: Fri, 13 Apr 2007 13:12:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash while mapping memory in pagetable_init() (Was: Re: .config)
References: <20070413174913.GA25234@ezr.goop.org> <20070413183841.GP10574@sequoia.sous-sol.org> <20070413190552.GQ10574@sequoia.sous-sol.org> <461FD97B.1010203@goop.org> <461FE36D.1050205@vmware.com>
In-Reply-To: <461FE36D.1050205@vmware.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Note you can always run out of space; to ensure safety, the init code
> needs to not use a fixed mapping size, it needs to map
> end_kernel_address + pae ? 1808k : 896k, assuming 128M vmalloc hole. 
> This could cause problems like running into initrd, however, so might
> require loader changes, or perhaps relocating the initrd.  Is the
> solution to just cap the kernel size at some fixed maximum?  6.2M
> appears to be the safe limit for all configurations.
>
> I'm pulling this back onto lkml; seems this is a serious bug which
> needs attention.  I've also cc'd some parties that might have relevant
> knowledge.  Why do I seem to recall head.S mapping 128M of mappings at
> one point in time? 

I just posted a patch.  Oops, forgot to Cc: Eric.

    J
