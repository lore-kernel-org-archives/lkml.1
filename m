Return-Path: <linux-kernel-owner+w=401wt.eu-S941153AbXHJQwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941153AbXHJQwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933661AbXHJQwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:52:06 -0400
Received: from web36609.mail.mud.yahoo.com ([209.191.85.26]:46846 "HELO
	web36609.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762484AbXHJQwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:52:04 -0400
X-YMail-OSG: uYuSMecVM1kqWbM390inIWJxwIyZmXAG3T.70hQ37pFXlrGgX16OEKOgF05PRTEvtlzUtba.bA--
X-RocketYMMF: rancidfat
Date: Fri, 10 Aug 2007 09:52:02 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 09/16] CacheFiles: Permit a process's create SID to be overridden [try #3]
To: David Howells <dhowells@redhat.com>, torvalds@osdl.org, akpm@osdl.org,
       steved@redhat.com, trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <20070810160543.24698.80481.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <236828.6019.qm@web36609.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Make it possible for a process's file creation SID to be temporarily
> overridden
> by CacheFiles so that files created in the cache have the right label
> attached.

I still object to the use of sids in LSM interfaces. I still owe you
a viable alternative.


Casey Schaufler
casey@schaufler-ca.com
