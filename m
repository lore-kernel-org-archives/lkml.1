Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbXITQJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbXITQJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbXITQJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:09:11 -0400
Received: from mx2.netapp.com ([216.240.18.37]:15209 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbXITQJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:09:10 -0400
X-IronPort-AV: E=Sophos;i="4.20,279,1186383600"; 
   d="scan'208";a="106097751"
Subject: Re: [PATCH 3/3] CRED: Move the effective capabilities into the
	cred struct
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: casey@schaufler-ca.com
Cc: Andrew Morgan <morgan@kernel.org>, David Howells <dhowells@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <176624.5520.qm@web36603.mail.mud.yahoo.com>
References: <176624.5520.qm@web36603.mail.mud.yahoo.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Thu, 20 Sep 2007 12:09:06 -0400
Message-Id: <1190304546.6763.86.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 20 Sep 2007 16:09:07.0892 (UTC) FILETIME=[92C2AF40:01C7FBA0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 08:36 -0700, Casey Schaufler wrote:

> Ok, what can't be copied, and why can't it be copied?

In practice, no security information can be copied because the checks
are all made on the "current" pointer. There is no mechanism other than
'current' for passing security information around.

Trond
