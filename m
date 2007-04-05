Return-Path: <linux-kernel-owner+w=401wt.eu-S1946091AbXDEIO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946091AbXDEIO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946092AbXDEIO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:14:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946091AbXDEIO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:14:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Jan Beulich" <jbeulich@novell.com>
X-Fcc: ~/Mail/linus
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <virtualization@lists.osdl.org>, "Andi Kleen" <ak@suse.de>,
       "lkml" <linux-kernel@vger.kernel.org>,
       "Zachary Amsden" <zach@vmware.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] Relocate VDSO ELF headers to match mapped
	location with COMPAT_VDSO
In-Reply-To: Jan Beulich's message of  Thursday, 5 April 2007 08:10:40 +0100 <4614BD10.76E4.0078.0@novell.com>
X-Shopping-List: (1) Bombastic suicides
   (2) Inconstant eruptions
   (3) Mrs. Leland's Bruisers
   (4) Fictitious educated hamster-lips
Message-Id: <20070405081415.E59E6180055@magilla.sf.frob.com>
Date: Thu,  5 Apr 2007 01:14:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In addition to Roland's remarks about missing symbol table relocation, I
> would also assume section headers, if present, should be relocated.

Yes, and also the .symtab as well as .dynsym just in case one ever has one
(though I think they are built stripped now, it's not hard to check sh_type
for SHT_SYMTAB and call the same routine that works from DT_SYMTAB).


Thanks,
Roland
