Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbYHEX22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbYHEX22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758294AbYHEX2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:28:20 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16057 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbYHEX2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:28:19 -0400
Date: Tue, 5 Aug 2008 16:22:55 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: mfasheh@suse.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2/cluster/netdebug.c: fix warning
Message-ID: <20080805232254.GO22600@mail.oracle.com>
Mail-Followup-To: Alexander Beregalov <a.beregalov@gmail.com>,
	mfasheh@suse.com, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
References: <20080805201036.GC17320@orion> <20080805202948.GL22600@mail.oracle.com> <20080805205041.GD17320@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805205041.GD17320@orion>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 12:50:41AM +0400, Alexander Beregalov wrote:
> On Tue, Aug 05, 2008 at 01:29:48PM -0700, Joel Becker wrote:
> > 	suseconds_t is a signed long.  Can you change the format to %ld
> > and cast to long?  Unfortunately, we need the cast, as sparc64 and
> > parisc treat it as int.
> 
> Then we should change cast from unsigned long to long for every tv_usec, right?

	Yup.

Joel

-- 

"You can get more with a kind word and a gun than you can with
 a kind word alone."
         - Al Capone

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
