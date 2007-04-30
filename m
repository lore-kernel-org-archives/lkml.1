Return-Path: <linux-kernel-owner+w=401wt.eu-S1946362AbXD3QeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946362AbXD3QeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946369AbXD3QeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:34:00 -0400
Received: from gw.goop.org ([64.81.55.164]:33733 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946372AbXD3Qd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:33:59 -0400
Message-ID: <46361A86.70408@goop.org>
Date: Mon, 30 Apr 2007 09:34:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@suse.de>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 05/12] i386: During page table initialization always set
 the leaf page table entries.
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>	<m18xc96eyq.fsf@ebiederm.dsl.xmission.com>	<m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com>	<m1zm4p509a.fsf_-_@ebiederm.dsl.xmission.com>	<m1vefd4zyj.fsf_-_@ebiederm.dsl.xmission.com> <m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
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
>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>   

Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

    J
