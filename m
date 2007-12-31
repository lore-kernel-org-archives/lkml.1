Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbXLaTnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbXLaTnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 14:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbXLaTnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 14:43:23 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:62300 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbXLaTnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 14:43:22 -0500
Date: Mon, 31 Dec 2007 11:41:46 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, ocfs2-devel@oss.oracle.com,
       LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [RFC][PATCH] byteorder: introduce le32_add_cpu & friends to
	core
Message-ID: <20071231194146.GT13821@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20071230190619.GA13757@joi> <20071230191825.GA6447@infradead.org> <20071230214857.GA14177@joi> <20071231091732.GA29043@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071231091732.GA29043@infradead.org>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 09:17:32AM +0000, Christoph Hellwig wrote:
> > be32_add is shorter than be32_add_cpu but I think it's not clear
> > whether second parameter is in native byte order or not.
> 
> Then again adding foreing endian values doesn't make much sense.
> 
> If you insist on your naming please make sure to convert ocfs and xfs
> to your naming.

Personally, I'd rather stick with the (IMHO) more descriptive name - btw,
the ones he picked don't require any extra conversion in Ocfs2.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
