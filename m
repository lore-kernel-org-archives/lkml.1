Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYJEVvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYJEVvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 17:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbYJEVvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 17:51:05 -0400
Received: from tundra.namei.org ([65.99.196.166]:41083 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbYJEVvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 17:51:04 -0400
Date: Mon, 6 Oct 2008 08:50:09 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: David Howells <dhowells@redhat.com>, Andrew Morton <akpm@osdl.org>,
       Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] user namespaces: introduce user_struct->user_namespace
 relationship
In-Reply-To: <20081004013644.GA24104@us.ibm.com>
Message-ID: <alpine.LRH.1.10.0810060846020.30516@tundra.namei.org>
References: <20081004013644.GA24104@us.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Serge E. Hallyn wrote:

> Hi James,
> 
> here are 3 patches to fix up the user namespaces a bit in preparation
> for real userns work to begin.  Andrew had suggested that these be
> rebased on top of your -next tree because they will conflict with
> the credentials work.  But it looks like much of the credentials stuff
> isn't in your next branch.  If you'd prefer that I port these to
> creds-next, please let me know.  I'll have to do it eventually :)

creds-next is dead.

Code ready for the next merge window is in the 'next' branch, while the 
current creds code is in the 'creds-next-subsys' branch, which hasn't been 
picked up in linux-next yet because of LPC and sfr's vacation.

When do you expect these patches to be sent upstream?  Are they ready now 
as an incremental change for 2.6.27?


- James
-- 
James Morris
<jmorris@namei.org>
