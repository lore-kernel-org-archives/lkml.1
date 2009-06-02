Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbZFBRHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbZFBRHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 13:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZFBRHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 13:07:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939AbZFBRHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 13:07:41 -0400
Date: Tue, 2 Jun 2009 10:06:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/23] vfs: Introduce infrastructure for revoking a
 file
In-Reply-To: <20090602071411.GE31556@wotan.suse.de>
Message-ID: <alpine.LFD.2.01.0906021005190.3351@localhost.localdomain>
References: <m1oct739xu.fsf@fess.ebiederm.org> <1243893048-17031-4-git-send-email-ebiederm@xmission.com> <20090602071411.GE31556@wotan.suse.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Jun 2009, Nick Piggin wrote:
>
> Why is it called hotplug? Does it have anything to do with hardware?
> Because every concurrently changed software data structure in the
> kernel can be "hot"-modified, right?
> 
> Wouldn't file_revoke_lock be more appropriate?

I agree, "hotplug" just sounds crazy. It's "open" and "revoke", not 
"plug" and "unplug".

		Linus
