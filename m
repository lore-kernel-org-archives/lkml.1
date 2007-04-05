Return-Path: <linux-kernel-owner+w=401wt.eu-S1946043AbXDEHcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946043AbXDEHcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 03:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946045AbXDEHcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 03:32:06 -0400
Received: from gw.goop.org ([64.81.55.164]:33734 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946043AbXDEHcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 03:32:02 -0400
Message-ID: <4614A5DA.9050700@goop.org>
Date: Thu, 05 Apr 2007 00:31:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, Roland McGrath <roland@redhat.com>,
       Andi Kleen <ak@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] Relocate VDSO ELF headers to match mapped	location
 with COMPAT_VDSO
References: <20070405045825.511024444@goop.org> <20070405045843.333498131@goop.org> <4614BD10.76E4.0078.0@novell.com>
In-Reply-To: <4614BD10.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> While there's a certain level of control on what DT_* may appear in the
> vDSO, not even considering other than the above types seems fragile to
> me. Since future additions to the set are supposedly following a fixed
> scheme (distinguishing pointers and values via the low bit when below
> OLD_DT_LOOS, and using sub-ranges when between DT_HIOS and
> OLD_DT_HIOS), at least also handling those would seem like a good
> idea, as would warning about unrecognized types.
>   

I wasn't aware of this scheme.  Where is it documented?

> Also, even though it shouldn't matter for the final result, if doing things
> spec-conforming here you should use d_un.d_ptr.
>   

Yes, I've already fixed that.

> In addition to Roland's remarks about missing symbol table relocation, I
> would also assume section headers, if present, should be relocated.
>   

Yes, I suppose that's easy enough to add.

    J
