Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbZAGSrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbZAGSrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZAGSq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:46:57 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:63911 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbZAGSqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:46:55 -0500
Subject: Re: Btrfs for mainline
From: Chris Mason <chris.mason@oracle.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Ryusuke Konishi <ryusuke@osrg.net>
In-Reply-To: <1231320811.30643.30.camel@macbook.infradead.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <1231270893.4888.19.camel@think.oraclecorp.com>
	 <1231320811.30643.30.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 13:45:57 -0500
Message-Id: <1231353957.5016.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.4964F868.0056:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 09:33 +0000, David Woodhouse wrote:
> On Tue, 2009-01-06 at 14:41 -0500, Chris Mason wrote:

> One more thing I'd suggest is removing the INSTALL file. The parts about
> having to build libcrc32c aren't relevant when it's part of the kernel
> tree and you have 'select LIBCRC32C', and the documentation on the
> userspace utilities probably lives _with_ the userspace repo. Might be
> worth adding a pointer to the userspace utilities though, in
> Documentation/filesystems/btrfs.txt
> 
> I think you can drop your own copy of the GPL too.
> 

I've pushed out your patch for this, thanks.

-chris


