Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbZFCQhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbZFCQhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbZFCQhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:37:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37297 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923AbZFCQhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:37:32 -0400
Message-ID: <4A26A689.1090300@redhat.com>
Date: Wed, 03 Jun 2009 12:36:25 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: "Larry H." <research@subreption.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change	ZERO_SIZE_PTR
 to point at unmapped space)
References: <20090530192829.GK6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain> <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com> <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com> <alpine.DEB.1.10.0906031047390.15621@gentwo.org> <1244041914.12272.64.camel@localhost.localdomain> <alpine.DEB.1.10.0906031134410.13551@gentwo.org> <20090603162831.GF6701@oblivion.subreption.com>
In-Reply-To: <20090603162831.GF6701@oblivion.subreption.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry H. wrote:

> Christopher, crippling the system is truly not the way to fix this.
> There are many legitimate users of private|fixed mappings at 0. In
> addition, if you want to go ahead and break POSIX, at least make sure
> your patch closes the loophole.

I suspect there aren't many at all, and restricting them through
SELinux may be enough to mitigate the risk.

> If SELinux isn't present, that's not useful. If mmap_min_addr is
> enabled, that still won't solve what my original, utterly simple patch
> fixes.

Would anybody paranoid run their system without SELinux?

> The patch provides a no-impact, clean solution to prevent kmalloc(0)
> situations from becoming a security hazard. Nothing else.

True, the changes in your patch only affect a few code paths.

-- 
All rights reversed.
