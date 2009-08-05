Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbZHEW7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbZHEW7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZHEW7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:59:50 -0400
Received: from tundra.namei.org ([65.99.196.166]:41915 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbZHEW7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:59:49 -0400
Date: Thu, 6 Aug 2009 08:59:25 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 5/6] KEYS: Make /proc/keys use keyid not numread as file
 position [ver #2]
In-Reply-To: <20090804203943.25094.68091.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.0908060857230.6643@tundra.namei.org>
References: <20090804203923.25094.78702.stgit@warthog.procyon.org.uk> <20090804203943.25094.68091.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009, David Howells wrote:

> From: Serge E. Hallyn <serue@us.ibm.com>
> 
> Make the file position maintained by /proc/keys represent the ID of the key
> just read rather than the number of keys read.  This should make it faster to
> perform a lookup as we don't have to scan the key ID tree from the beginning to
> find the current position.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> Signed-off-by: David Howells <dhowells@redhat.com>


This does not apply to my tree:

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

Looks like it's due to pending changes in the same file.  Could you please 
generate this patch against my tree? 


- James
-- 
James Morris
<jmorris@namei.org>
