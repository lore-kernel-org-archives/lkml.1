Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZBWUlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZBWUlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZBWUlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:41:06 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43517 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZBWUlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:41:03 -0500
Date: Mon, 23 Feb 2009 14:40:41 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 4/4] keys: make procfiles per-user-namespace
Message-ID: <20090223204041.GA31626@us.ibm.com>
References: <20090109225313.GB15599@us.ibm.com> <20090109225208.GA15252@us.ibm.com> <5296.1234522990@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5296.1234522990@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > Restrict the /proc/keys and /proc/key-users output to keys
> > belonging to the same user namespace as the reading task.
> > 
> > We may want to make this more complicated - so that any
> > keys in a user-namespace which is belongs to the reading
> > task are also shown.  But let's see if anyone wants that
> > first.
> 
> Hmmm...  I wonder if we can do better by making the file position indicate the
> key ID rather than being a count of the number of keys read.  It might make
> this cleaner.

file position?  as in the result of lseek(fd, 0, SEEK_CUR)?

I don't understand what you're suggesting.

-serge
