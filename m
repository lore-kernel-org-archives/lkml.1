Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbZHDXjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbZHDXjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 19:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZHDXjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 19:39:08 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:35620 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZHDXjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 19:39:07 -0400
Date: Tue, 4 Aug 2009 18:39:06 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 4/6] KEYS: Add garbage collection for dead, revoked and
	expired keys. [ver #2]
Message-ID: <20090804233906.GA17407@us.ibm.com>
References: <20090804203923.25094.78702.stgit@warthog.procyon.org.uk> <20090804203938.25094.21014.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804203938.25094.21014.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Add garbage collection for dead, revoked and expired keys.  This involved
> erasing all links to such keys from keyrings that point to them.  At that
> point, the key will be deleted in the normal manner.
> 
> Keyrings from which garbage collection occurs are shrunk and their quota
> consumption reduced as appropriate.
> 
> Dead keys (for which the key type has been removed) will be garbage collected
> immediately.
> 
> Revoked and expired keys will hang around for a number of seconds, as set in
> /proc/sys/kernel/keys/gc_delay before being automatically removed.  The default
> is 5 minutes.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>
