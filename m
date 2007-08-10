Return-Path: <linux-kernel-owner+w=401wt.eu-S942037AbXHJVFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942037AbXHJVFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbXHJVF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:05:28 -0400
Received: from relay1.vsu.ru ([62.76.169.14]:55221 "EHLO relay1.vsu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259AbXHJVF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:05:27 -0400
From: Vladimir Volovich <vvv@vsu.ru>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org
Subject: Re: nfs - duplicate directory entries
References: <87fy2rgpqs.fsf@vvv.vsu.ru>
	<1186778529.6642.52.camel@heimdal.trondhjem.org>
Date: Sat, 11 Aug 2007 01:05:22 +0400
In-Reply-To: <1186778529.6642.52.camel@heimdal.trondhjem.org> (Trond
	Myklebust's message of "Fri\, 10 Aug 2007 16\:42\:09 -0400")
Message-ID: <873ayrgkx9.fsf@vvv.vsu.ru>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"TM" == Trond Myklebust writes:

 >> i.e. the current directory contains sub-directory 112920 twice,
 >> sub-directory 112921 twice, etc. - and the inode numbers are the
 >> same.

 TM> That can happen if the NFS server doesn't send unique cookies.

i have 2 questions:

1) how to debug this, to confirm that this is caused by NFS server not
   sending unique cookies? (to try to report to the "vendor" of the
   NFS server)

2) does it make sence to try to gracefully work-around this problem on
   the linux side? or would it significantly complicate things?

Best,
v.
