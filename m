Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbYBIAXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbYBIAXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbYBIAXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:23:21 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35980 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752827AbYBIAXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:23:19 -0500
Date: Fri, 8 Feb 2008 18:23:17 -0600
From: Paul Jackson <pj@sgi.com>
To: corbet@lwn.net (Jonathan Corbet)
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Documenting patch tags yet one more time
Message-Id: <20080208182317.525c4d1f.pj@sgi.com>
In-Reply-To: <27099.1202503342@vena.lwn.net>
References: <20080208130126.e05be25d.pj@sgi.com>
	<27099.1202503342@vena.lwn.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon wrote:
> So here's a version which merges the information into
> SubmittingPatches instead.

Reviewed-by: Paul Jackson <pj@sgi.com>

---

That's my first time using that tag ... fun.  Now I'm wondering if there
might be some improvements that you, me, or someone could make to the
SubmittingPatches file that would explain more clearly that PATCH's
should start off, right from the top or after the initial From: line if
present, with:

  - The body of the explanation, which will be copied to the
    permanent changelog to describe this patch.

rather than opening with ephemeral reactions to the discussion of the
moment which will make little "sense to a competent reader who has long
since forgotten the immediate details of the discussion that might have
led to this patch."

As best my legalistic mind understands the patch format, such ephemeral
reactions should go after the "---" marker line, in the same section as
the diffstat would be placed.

Or perhaps the patch format should be changed in this regard, since it
is cumbersome and unnatural to embed the ephemeral opening comments
half way down the patch, rather than opening with them.  I don't know.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
