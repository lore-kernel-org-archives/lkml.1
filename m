Return-Path: <linux-kernel-owner+w=401wt.eu-S933145AbZKXUcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbZKXUcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932736AbZKXUcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:32:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51719 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718AbZKXUcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:32:24 -0500
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo@firstfloor.org,
       "Molnar <mingo"@firstfloor.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 14/14] utrace core
From: Andi Kleen <andi@firstfloor.org>
References: <20091124200220.GA5828@redhat.com>
Date: Tue, 24 Nov 2009 21:32:27 +0100
In-Reply-To: <20091124200220.GA5828@redhat.com> (Oleg Nesterov's message of "Tue, 24 Nov 2009 21:02:20 +0100")
Message-ID: <87my2bwtno.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> From: Roland McGrath <roland@redhat.com>
>
> This adds the utrace facility, a new modular interface in the kernel
> for implementing user thread tracing and debugging.  This fits on top
> of the tracehook_* layer, so the new code is well-isolated.

Could we just drop the tracehook layer if this finally merged
and call the low level functions directly?

It might have been reasonably early on when it was still out of tree,
but longer term when it's integrated having strange opaque hooks
like that just makes the coder harder to read and maintain.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
