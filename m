Return-Path: <linux-kernel-owner+w=401wt.eu-S1763615AbZBYXxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763615AbZBYXxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbZBYXxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:53:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55672 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbZBYXx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:53:29 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090225210336.GA20086@us.ibm.com>
References: <20090225210336.GA20086@us.ibm.com> <20090223204041.GA31626@us.ibm.com> <20090109225313.GB15599@us.ibm.com> <20090109225208.GA15252@us.ibm.com> <5296.1234522990@redhat.com> <16728.1235565664@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 4/4] keys: make procfiles per-user-namespace
Date: Wed, 25 Feb 2009 23:53:22 +0000
Message-ID: <7386.1235606002@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> So you want users to be able to mmap the file and lseek to a particular
> spot?

mmap?  *blink*

> Meanwhile, do you have any objections to these 4 patches?  :)

Not really.  You can add my Acked-by.  It's just that mapping fpos to keyid
might simplify the code.

David
