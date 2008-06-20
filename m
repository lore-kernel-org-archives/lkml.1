Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbYFTFp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbYFTFp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 01:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYFTFpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 01:45:13 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:42082 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750889AbYFTFpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 01:45:12 -0400
Date: Fri, 20 Jun 2008 07:45:04 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: Miquel van Smoorenburg <mikevs@xs4all.net>,
       Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       xfs-masters@oss.sgi.com
Subject: Re: XFS internal error xfs_trans_cancel at line 1163 of file
	fs/xfs/xfs_trans.c
Message-ID: <20080620054504.GA2075@anita>
Mail-Followup-To: Miquel van Smoorenburg <mikevs@xs4all.net>,
	Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	xfs-masters@oss.sgi.com
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de> <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com> <1213309629.29745.8.camel@localhost.localdomain> <20080613030841.GC3700@disturbed> <20080620052716.GA2022@anita>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620052716.GA2022@anita>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again. Before strace looks weird, this looks like the old one:

ksymoops 2.4.11 on x86_64 2.6.26-rc6.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.26-rc6/ (default)
     -m /usr/src/linux-2.6.26-rc6/System.map (specified)

Error (regular_file): read_ksyms stat /proc/ksyms failed
ksymoops: No such file or directory
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Pid: 2137, comm: fetchnews Not tainted 2.6.26-rc6 #1
Call Trace:
 [<ffffffff802ffa42>]
 [<ffffffff802fa35a>]
 [<ffffffff802ffa42>]
 [<ffffffff80308a29>]
 [<ffffffff80262799>]
 [<ffffffff8026500a>]
 [<ffffffff80223506>]
 [<ffffffff8023116c>]
 [<ffffffff8025a0fa>]
 [<ffffffff8020afab>]
Warning (Oops_read): Code line not seen, dumping what data is available


Trace; ffffffff802ffa42 <xfs_create+41d/462>
Trace; ffffffff802fa35a <xfs_trans_cancel+56/ee>
Trace; ffffffff802ffa42 <xfs_create+41d/462>
Trace; ffffffff80308a29 <xfs_vn_mknod+148/229>
Trace; ffffffff80262799 <vfs_create+75/ba>
Trace; ffffffff8026500a <do_filp_open+1dc/7c5>
Trace; ffffffff80223506 <ns_to_timeval+9/27>
Trace; ffffffff8023116c <__remove_hrtimer+6b/78>
Trace; ffffffff8025a0fa <do_sys_open+4a/f1>
Trace; ffffffff8020afab <system_call_after_swapgs+7b/80>


1 warning and 1 error issued.  Results may not be reliable.


-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
