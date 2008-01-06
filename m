Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYAFUxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYAFUxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 15:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYAFUw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 15:52:56 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:28527 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYAFUwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 15:52:54 -0500
Date: Sun, 6 Jan 2008 12:50:55 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       OCFS2-devel <ocfs2-devel@oss.oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       xfs-masters@oss.sgi.com
Subject: Re: [PATCH 1/3] byteorder: move le32_add_cpu & friends from OCFS2
	to core
Message-ID: <20080106205055.GR23506@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <1199547382-29969-1-git-send-email-marcin.slusarz@gmail.com> <1199547382-29969-2-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199547382-29969-2-git-send-email-marcin.slusarz@gmail.com>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 04:36:20PM +0100, marcin.slusarz@gmail.com wrote:
> - move inline functions which add native byte order variable to
>   little/big endian variable to core header
>   * le16_add_cpu(__le16 *var, u16 val)
>   * le32_add_cpu(__le32 *var, u32 val)
>   * le64_add_cpu(__le64 *var, u64 val)
>   * be32_add_cpu(__be32 *var, u32 val)
> - add for completeness:
>   * be16_add_cpu(__be16 *var, u16 val)
>   * be64_add_cpu(__be64 *var, u64 val)
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
