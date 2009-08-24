Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbZHXSlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbZHXSlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZHXSlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:41:04 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:62575 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbZHXSlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:41:03 -0400
Date: Mon, 24 Aug 2009 11:40:09 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Mark Fasheh <mfasheh@suse.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 12/17] ocfs2: Update syncing after
 splicing to match generic version
Message-ID: <20090824184009.GC7698@mail.oracle.com>
Mail-Followup-To: Mark Fasheh <mfasheh@suse.com>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
 <1250875447-15622-13-git-send-email-jack@suse.cz>
 <20090824183543.GF2818@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824183543.GF2818@wotan.suse.de>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A92DEB8.0039:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 11:35:43AM -0700, Mark Fasheh wrote:
> On Fri, Aug 21, 2009 at 07:24:02PM +0200, Jan Kara wrote:
> > Update ocfs2 specific splicing code to use generic syncing helper. The sync now
> > does not happen under rw_lock because generic_write_sync() acquires i_mutex
> > which ranks above rw_lock. That should not matter because standard fsync path
> > does not hold it either.
> 
> Thanks Jan,
> 
> Acked-by: Mark Fasheh <mfasheh@suse.com>

<aol>Me too!</aol>
Acked-by: Joel Becker <joel.becker@oracle.com>

Joel

-- 

A good programming language should have features that make the
kind of people who use the phrase "software engineering" shake
their heads disapprovingly.
	- Paul Graham

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
