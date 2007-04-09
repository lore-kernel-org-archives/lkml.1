Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbXDIQjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbXDIQjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXDIQjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:39:00 -0400
Received: from lazybastard.de ([212.112.238.170]:60055 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbXDIQi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:38:58 -0400
Date: Mon, 9 Apr 2007 18:34:37 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
Subject: Re: Interface for the new fallocate() system call
Message-ID: <20070409163436.GA24012@lazybastard.org>
References: <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071929.GC8365@osiris.boeblingen.de.ibm.com> <17932.54606.323431.491736@cargo.ozlabs.ibm.com> <20070330104449.GA9371@lazybastard.org> <17946.14646.808334.441833@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17946.14646.808334.441833@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 April 2007 23:01:42 +1000, Paul Mackerras wrote:
> Jörn Engel writes:
> 
> > Wouldn't that work be confined to fallocate()?  If I understand Heiko
> > correctly, the alternative would slow s390 down for every syscall,
> > including more performance-critical ones.
> 
> The alternative that Jakub suggested wouldn't slow s390 down.

True.  And it appears to be one of the least offensive options we have.

Jörn

-- 
My second remark is that our intellectual powers are rather geared to
master static relations and that our powers to visualize processes
evolving in time are relatively poorly developed.
-- Edsger W. Dijkstra
