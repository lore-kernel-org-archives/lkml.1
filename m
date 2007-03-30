Return-Path: <linux-kernel-owner+w=401wt.eu-S1751141AbXC3Mzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbXC3Mzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 08:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXC3Mzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 08:55:44 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:1587 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbXC3Mzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 08:55:42 -0400
Date: Fri, 30 Mar 2007 14:55:38 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
Subject: Re: Interface for the new fallocate() system call
Message-ID: <20070330125538.GE8365@osiris.boeblingen.de.ibm.com>
References: <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071929.GC8365@osiris.boeblingen.de.ibm.com> <17932.54606.323431.491736@cargo.ozlabs.ibm.com> <20070330104449.GA9371@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070330104449.GA9371@lazybastard.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 12:44:49PM +0200, Jörn Engel wrote:
> On Fri, 30 March 2007 19:15:58 +1000, Paul Mackerras wrote:
> > It does mean extra unnecessary work for 64-bit platforms, though...
> 
> Wouldn't that work be confined to fallocate()?  If I understand Heiko
> correctly, the alternative would slow s390 down for every syscall,
> including more performance-critical ones.

That is correct.
