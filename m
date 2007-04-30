Return-Path: <linux-kernel-owner+w=401wt.eu-S1423603AbXD3Q0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423603AbXD3Q0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423444AbXD3Q0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:26:15 -0400
Received: from ns2.suse.de ([195.135.220.15]:37672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946378AbXD3QZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:25:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 05/12] i386: During page table initialization always set the leaf page table entries.
Date: Mon, 30 Apr 2007 18:21:42 +0200
User-Agent: KMail/1.9.6
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com> <m1vefd4zyj.fsf_-_@ebiederm.dsl.xmission.com> <m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301821.42944.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2007 18:03:27 Eric W. Biederman wrote:
> 
> If we don't set the leaf page table entries it is quite possible that
> will inherit and incorrect page table entry from the initial boot
> page table setup in head.S.  So we need to redo the effort here,
> so we pick up PSE, PGE and the like.
> 
> Hypervisors like Xen require that their page tables be read-only,
> which is slightly incompatible with our low identity mappings, however
> I discussed this with Jeremy he has modified the Xen early set_pte
> function to avoid problems in this area.
> 
> Andi I sent this once a part of the discussion on this issue so
> you may already have this patch in your queue.

I hadn't but i merged it now into the original patch thanks

-Andi
