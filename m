Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbZBMLDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbZBMLDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 06:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZBMLDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 06:03:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57977 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbZBMLDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 06:03:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090109225313.GB15599@us.ibm.com>
References: <20090109225313.GB15599@us.ibm.com> <20090109225208.GA15252@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 4/4] keys: make procfiles per-user-namespace
Date: Fri, 13 Feb 2009 11:03:10 +0000
Message-ID: <5296.1234522990@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> Restrict the /proc/keys and /proc/key-users output to keys
> belonging to the same user namespace as the reading task.
> 
> We may want to make this more complicated - so that any
> keys in a user-namespace which is belongs to the reading
> task are also shown.  But let's see if anyone wants that
> first.

Hmmm...  I wonder if we can do better by making the file position indicate the
key ID rather than being a count of the number of keys read.  It might make
this cleaner.

David
