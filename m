Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbZFPKih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbZFPKih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZFPKi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:38:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55371 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbZFPKi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:38:28 -0400
Date: Tue, 16 Jun 2009 06:38:23 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steve French <sfrench@us.ibm.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: cifs tree build warning
Message-ID: <20090616063823.688c93c2@tlielax.poochiereds.net>
In-Reply-To: <20090616160751.4acfdf1d.sfr@canb.auug.org.au>
References: <20090616160751.4acfdf1d.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 16:07:51 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Steve,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> fs/cifs/dns_resolve.c: In function 'is_ip':
> fs/cifs/dns_resolve.c:42: warning: passing argument 1 of 'cifs_convert_address' discards qualifiers from pointer target type
> fs/cifs/cifsproto.h:77: note: expected 'char *' but argument is of type 'const char *'
> 
> Introduced by commit 1e68b2b2756fc3488ecbade5ad5f13302b3aaafc ("cifs: add
> new routine for converting AF_INET and AF_INET6 addrs").
> 

Known problem. The warning is pretty harmless (that variable doesn't
ever get changed). Once Steve commits the last patch in that series
the warning will go away.

-- 
Jeff Layton <jlayton@redhat.com>
