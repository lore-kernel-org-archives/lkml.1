Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZIWDQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZIWDQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 23:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZIWDQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 23:16:39 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:23741 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbZIWDQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 23:16:38 -0400
Date: Tue, 22 Sep 2009 20:14:50 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the ocfs2 tree with Linus' tree
Message-ID: <20090923031450.GB29799@mail.oracle.com>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090923104537.2885f67a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923104537.2885f67a.sfr@canb.auug.org.au>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AB99313.00D6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 10:45:37AM +1000, Stephen Rothwell wrote:
> Today's linux-next merge of the ocfs2 tree got conflicts in
> arch/x86/ia32/ia32entry.S, arch/x86/include/asm/unistd_32.h,
> arch/x86/include/asm/unistd_64.h and arch/x86/kernel/syscall_table_32.S
> between various commits from Linus' tree and commit
> 25767b48501de19421ae86c406b2dd42df37baf3 ("fs: Add the reflink()
> operation and reflinkat(2) system call") from the ocfs2 tree.
> 
> I fixed it up (see below) and can carry the fix for a short while.  Given
> the ongoing discussions about this patch with Linus, however, it may be
> worth dropping for now?

	The syscall is dropping while it's reworked.  I should have a
tree up shortly without the syscall.

Joel

-- 

Life's Little Instruction Book #15

	"Own a great stereo system."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
