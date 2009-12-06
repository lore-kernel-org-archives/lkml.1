Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbZLFBNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbZLFBNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 20:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbZLFBN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 20:13:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54556 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbZLFBN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 20:13:27 -0500
Date: Sun, 6 Dec 2009 01:13:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: viro@ftp.linux.org.uk, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 7/18] kill useless checks in sparc mremap variants
Message-ID: <20091206011332.GA14381@ZenIV.linux.org.uk>
References: <E1NGzzu-0008RV-Tx@ZenIV.linux.org.uk> <20091205.150941.142886510.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091205.150941.142886510.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 05, 2009 at 03:09:41PM -0800, David Miller wrote:
> From: Al Viro <viro@ftp.linux.org.uk>
> Date: Sat, 05 Dec 2009 19:08:50 +0000
> 
> > 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

BTW, do we need sys32_mremap() after that?  The only difference between
it and sys_mremap() that we have new_addr u32 in the former and u64 in
the latter and IIRC the upper 32 bits of %i4 are going to be 0 anyway...
