Return-Path: <linux-kernel-owner+w=401wt.eu-S935444AbXHIRFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935444AbXHIRFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765497AbXHIRE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:04:59 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:20297 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761060AbXHIRE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:04:58 -0400
X-YMail-OSG: UZXceBQVM1lp4xHPDQbajnJp1IR38FktV14eiDp6
X-RocketYMMF: rancidfat
Date: Thu, 9 Aug 2007 10:04:56 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 09/14] CacheFiles: Permit a process's create SID to be overridden [try #2]
To: David Howells <dhowells@redhat.com>, torvalds@osdl.org, akpm@osdl.org,
       steved@redhat.com, trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070809160525.17906.35400.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <830177.29212.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Make it possible for a process's file creation SID to be temporarily
> overridden
> by CacheFiles so that files created in the cache have the right label
> attached.
> 
> Without this facility, files created in the cache will be given the current
> file creation SID of whatever process happens to have invoked CacheFiles
> indirectly by means of opening a netfs file at the time the cache file is
> created.

This is SELinux specific funtionality and should be done in the
SELinux code. You should not be adding interfaces that are SELinux
specific, in this case using secids instead of the LSM blob interfaces.


Casey Schaufler
casey@schaufler-ca.com
