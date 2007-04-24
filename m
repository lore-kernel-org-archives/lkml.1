Return-Path: <linux-kernel-owner+w=401wt.eu-S1030962AbXDXAel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030962AbXDXAel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030964AbXDXAel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:34:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:41363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030962AbXDXAek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:34:40 -0400
From: Neil Brown <neilb@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Date: Tue, 24 Apr 2007 10:34:31 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17965.20631.736307.24491@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SLUB: kmem_cache_destroy doesn't - version 2.
In-Reply-To: message from Christoph Lameter on Monday April 23
References: <17960.16739.870487.497750@notabene.brown>
	<Pine.LNX.4.64.0704192215420.16306@schroedinger.engr.sgi.com>
	<17960.20796.761309.771912@notabene.brown>
	<Pine.LNX.4.64.0704192236510.16503@schroedinger.engr.sgi.com>
	<17964.21972.961812.744601@notabene.brown>
	<Pine.LNX.4.64.0704231340180.512@schroedinger.engr.sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday April 23, clameter@sgi.com wrote:
> Would this work? Contains a solution somewhat along the lines of your 
> thoughts on the subject.
> 

Concept seems sound.
Code needs a kfree of the name returned by create_unique_id, and I
think ID_STR_LENGTH needs to be at least 34.
Maybe that should be allocated on the stack in sysfs_slab_add, rather
than using kmalloc/free.

Thanks,
NeilBrown
