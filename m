Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbZGUAaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbZGUAaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 20:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZGUAaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 20:30:05 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:17180 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbZGUAaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 20:30:03 -0400
Date: Mon, 20 Jul 2009 17:28:22 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix compilation warning for fs/ocfs2/xattr.c
Message-ID: <20090721002822.GB9183@mail.oracle.com>
Mail-Followup-To: Subrata Modak <subrata@linux.vnet.ibm.com>,
	ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>,
	Sachin P Sant <sachinp@linux.vnet.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20090713194928.32372.56679.sendpatchset@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090713194928.32372.56679.sendpatchset@subratamodak.linux.ibm.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4A650BF2.0094:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 01:19:31AM +0530, Subrata Modak wrote:
> gcc 4.4.1 generates the following build warning on i386:
> 
> CC [M]  fs/ocfs2/xattr.o
> fs/ocfs2/xattr.c: In function ‘ocfs2_xattr_block_get’:
> fs/ocfs2/xattr.c:1055: warning: ‘block_off’ may be used uninitialized in this function
> 
> The following fix is based on a similar approach by David Howells
> few days back: http://lkml.org/lkml/2009/7/9/109,
> 
> Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,

	This is now in the fixes branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #15

	"Own a great stereo system."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
